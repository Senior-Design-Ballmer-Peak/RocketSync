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
            ZStack {
                Image("Icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color("TextColor"), lineWidth: 5))
            }
            
            Text("RocketSync")
                .font(.title)
                .fontWidth(.expanded)
                .foregroundColor(Color("TextColor"))
                .padding(.all)
            
            Spacer()
            
            TextField("Email Address", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .focused($emailIsFocused)
                .submitLabel(.next)
            
            
            SecureField("Password", text: $password)
                .submitLabel(.next)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($passwordIsFocused)
                .padding(.horizontal)
                .padding(.bottom, 20)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.done)

                
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
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color.blue))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal)
                    
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
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color.green))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal)
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
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(RoundedRectangle(cornerRadius: 25).fill(.red))
                .foregroundStyle(Color.white)
                .padding(.horizontal)
            
            Text("Sign in with Apple")
                .onTapGesture {
                    Task {
                        await authModel.login(with: .signInWithApple)
                        if authModel.state == .signedIn {
                            isAuthenticated = true
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(RoundedRectangle(cornerRadius: 25).fill(Color.primary))
                .foregroundStyle(Color.background)
                .padding(.horizontal)
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
