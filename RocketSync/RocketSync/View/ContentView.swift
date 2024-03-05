//
//  ContentView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/4/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authModel: AuthenticationModel
    var hasPersistedSignedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    
    var body: some View {
        NavigationStack {
            if authModel.state == .signedOut && !hasPersistedSignedIn {
                LoginView()
            } else {
                PostsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
