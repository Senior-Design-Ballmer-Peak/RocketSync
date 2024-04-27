//
//  ContentView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/4/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var titleAppears = false
    private let animation = Animation.bouncy(duration: 2)
    var showAnimation = false
    @State var selectedTab: Int = 0
    @EnvironmentObject var authModel: AuthenticationModel
    var postController = PostsController()
    var hasPersistedSignedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @State private var isCreatePostViewPresented = false
    
    var body: some View {
        NavigationStack {
            if authModel.state == .signedOut && !hasPersistedSignedIn {
                LoginView()
            } else {
                
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
                    
                    DeviceConnectionView(postController: postController)
                        .tabItem {
                            Label("L-TAS", systemImage: "location.north.line.fill")
                        }
                        .tag(2)
                    
                    ProfileView(postController: postController, userName: Auth.auth().currentUser?.displayName ?? "")
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                        .tag(3)
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
                        switch(selectedTab) {
                        case 0:
                            isCreatePostViewPresented.toggle()
                        case 3:
                            authModel.signOut()
                        default:
                            print("")
                        }
                        
                    }, label: {
                        switch(selectedTab) {
                        case 0:
                            Image(systemName: "plus.bubble")
                                .foregroundStyle(Color("TextColor"))
                        case 3:
                            Text("Sign Out")
                                .foregroundStyle(Color("TextColor"))
                        default:
                            Text("").hidden()
                        }
                    })
                )
            }
        }
        
        //
                    
        //
        .sheet(isPresented: $isCreatePostViewPresented, content: {
            CreatePostView()
                .padding()
                .cornerRadius(20)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.automatic)
        })
    }
}

#Preview {
    ContentView()
}
