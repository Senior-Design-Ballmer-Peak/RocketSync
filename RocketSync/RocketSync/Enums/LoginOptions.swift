//
//  LoginOptions.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/4/24.
//

import Foundation

enum LoginOption {
    case emailAndPassword(email: String, password: String)
    case signInWithGoogle
    case signInWithApple
}
