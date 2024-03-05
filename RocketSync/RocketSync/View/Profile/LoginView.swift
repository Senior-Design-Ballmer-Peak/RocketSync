//
//  LoginView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/3/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAuthLoader: Bool = false
    @State private var showInvalidPWAlert: Bool = false
    @State private var isAuthenticated: Bool = false
    @FocusState private var emailIsFocused: Bool
    @FocusState private var passwordIsFocused: Bool
    @EnvironmentObject var authModel: AuthenticationModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("Email Address", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .focused($emailIsFocused)
                .submitLabel(.next)
            
            SecureField("Password", text: $password)
                .submitLabel(.next)
                .focused($passwordIsFocused)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                
            Button(action: {
                showAuthLoader = true
                Task {
                    await authModel.login(with: .emailAndPassword(email: email, password: password))
                }
                
                if authModel.state != .signedIn {
                    showInvalidPWAlert = true
                } else {
                    isAuthenticated = true
                }
                
                showAuthLoader = false
            }, label: {
                Text("Log In")
                    .disabled(email.isEmpty || password.isEmpty)
                    .alert(isPresented: $showInvalidPWAlert) {
                        Alert(title: Text("Email or Password is incorrect"))
                    }
                    .frame(width: 200, height: 40)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(.background)))
            })
            
            Button(action: {
                showAuthLoader = true
                Task {
                    await authModel.signUp(email: email, password: password)
                }
                
                if authModel.state != .signedIn {
                    showInvalidPWAlert = true
                } else {
                    isAuthenticated = true
                }
                
                showAuthLoader = false
            }, label: {
                Text("Sign Up")
                    .disabled(email.isEmpty || password.isEmpty)
                    .alert(isPresented: $showInvalidPWAlert) {
                        Alert(title: Text("Email or Password is incorrect"))
                    }
                    .frame(width: 200, height: 40)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(.background)))
            })
            
            
            Text("Sign in with Google")
                .onTapGesture {
                    Task {
                        await authModel.login(with: .signInWithGoogle)
                        if authModel.state == .signedIn {
                            isAuthenticated = true
                        }
                    }
                }
                .frame(width: 200, height: 40)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(.background)))
            
            Text("Sign in with Apple")
                .onTapGesture {
                    Task {
                        await authModel.login(with: .signInWithApple)
                        if authModel.state == .signedIn {
                            isAuthenticated = true
                        }
                    }
                }
                .frame(width: 200, height: 40)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(.background)))
                
                    

            
            

        }
        .padding(.all)
        
        Spacer()
        
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView()
}
