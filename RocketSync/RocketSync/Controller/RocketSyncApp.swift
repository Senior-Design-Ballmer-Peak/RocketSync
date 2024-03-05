//
//  RocketSyncApp.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI
import Firebase

@main
struct RocketSyncApp: App {
    @StateObject var authModel = AuthenticationModel()
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authModel)
        }
    }
}
