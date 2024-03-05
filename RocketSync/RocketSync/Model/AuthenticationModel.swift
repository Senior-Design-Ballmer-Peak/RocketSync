//
//  AuthenticationModel.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/4/24.
//

import Foundation
import Firebase
import GoogleSignIn
import AuthenticationServices
import CryptoKit

class AuthenticationModel: NSObject, ObservableObject {
    
    enum SignInState {
        case signedIn
        case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    @Published var errorMessage: String = ""
    @Published var signInMethod: String = "Unkonwn"
    @Published var restoreGoogleSignIn: Bool = false
    fileprivate var currentNonce: String?
    
    override init() {
        super.init()
        
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            restoreGoogleSignIn = true
        }
    }
    
    func login(with loginOption: LoginOption) async {
        switch loginOption  {
        case let .emailAndPassword(email, password):
            await signInWithEmail(email: email, password: password)
        case .signInWithGoogle:
            await signInWithGoogle()
        case.signInWithApple:
            signInWithApple()
        }
    }
    
    @MainActor
    func signInWithEmail(email: String, password: String) async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            self.state = .signedIn
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            self.signInMethod = "Email / Password"
        } catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func signUp(email: String, password: String) async {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            self.state = .signedIn
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            self.signInMethod = "Email / Password"
        } catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    
    //MARK: - Google Sign In
    
    @MainActor
    func signInWithGoogle() async {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            do {
                let result = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
                print("Restoring previous session")
                await authenticateGoogleUser(for: result)
            } catch {
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
            }
        } else {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            do {
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                await authenticateGoogleUser(for: result.user)
            } catch {
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func authenticateGoogleUser(for user: GIDGoogleUser?) async {
        guard let idToken = user?.idToken?.tokenString else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user?.accessToken.tokenString ?? "")
        
        do {
            try await Auth.auth().signIn(with: credentials)
            self.state = .signedIn
            UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
            self.signInMethod = "Google"
        } catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    
    //MARK: - Apple Sign In
    
    func signInWithAppleHandler(credentials: OAuthCredential) {
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                self.errorMessage = error?.localizedDescription ?? "Error"
            } else {
                self.state = .signedIn
                UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
                self.signInMethod = "Apple"
            }
        }
    }
    
    //MARK: - Signing Out
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.state = .signedOut
            restoreGoogleSignIn = false
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Apple Authentication Extension
extension AuthenticationModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func signInWithApple() {
        let nonce = String.randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.sha256
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = scenes?.windows.first else { return UIWindow() }
        return window
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            self.signInWithAppleHandler(credentials: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple error: \(error)")
    }
}

extension String {
    var sha256: String {
        let inputData = Data(self.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}
