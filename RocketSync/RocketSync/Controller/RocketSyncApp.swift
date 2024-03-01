//
//  RocketSyncApp.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI
import SwiftData

@main
struct RocketSyncApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Post.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            PostsView()
        }
        .modelContainer(sharedModelContainer)
    }
}
