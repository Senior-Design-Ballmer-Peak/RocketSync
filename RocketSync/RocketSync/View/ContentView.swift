//
//  ContentView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var titleAppears = false
    private let animation = Animation.bouncy(duration: 2)
    var showAnimation = false
    @State var selectedTab: Int = 0
    @EnvironmentObject var authModel: AuthenticationModel
    var postController = PostsController()
    var hasPersistedSignedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    
    var body: some View {
        NavigationStack {
            if authModel.state == .signedOut && !hasPersistedSignedIn {
                LoginView()
            } else {
                
                //                    Image(systemName: "location.north")
                //                        .foregroundColor(Color("TextColor"))
                //                        .id(titleAppears)
                //                        .transition(PushTransition(edge: .bottom))
                //                        .onAppear{ titleAppears.toggle() }
                //                        .animation(animation, value: titleAppears)
                
                TabView(selection: $selectedTab) {
                    PostsView(postController: postController)
                        .tabItem {
                            Label("Posts", systemImage: "aqi.medium")
                        }
                        .tag(0)
                    
                    DistanceMeasureView()
                        .tabItem {
                            Label("Distance", systemImage: "scope")
                        }
                        .tag(1)
                    
                    DeviceConnectionView()
                        .tabItem {
                            Label("L-TAS", systemImage: "location.north.line.fill")
                        }
                        .tag(2)
                    
                    ProfileView(postController: postController)
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                        .tag(3)
//                    
//                    SettingsView()
//                        .tabItem {
//                            Label("Settings", systemImage: "gear")
//                        }
//                        .tag(4)
//                    DesignPostView()
//                        .tabItem {
//                            Label("Scan Rocket", systemImage: "laser.burst")
//                        }
//                        .tag(5)
                }
                .accentColor(Color("TextColor"))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: HStack {
                        Image(systemName: "location.north")
                            .foregroundColor(Color("TextColor"))
                            .id(titleAppears)
                            .transition(PushTransition(edge: .bottom))
                            .onAppear{ titleAppears.toggle() }
                            .animation(animation, value: titleAppears)
                        
                        Text("RocketSync")
                            .font(.title)
                            .fontWidth(.expanded)
                            .foregroundColor(Color("TextColor"))
                            .id(titleAppears)
                            .transition(PushTransition(edge: .top))
                            .animation(animation, value: titleAppears)
                        
                    },
                    trailing: Button(action: {
                        
                    }) {
                        Image(systemName: "gear")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.primary)
                            .font(.title)
                    }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
