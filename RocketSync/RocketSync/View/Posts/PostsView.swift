//
//  ContentView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI
import SwiftData

struct PostsView: View {
    @Environment(\.modelContext) private var modelContext
//    @Query private var posts: [Post]
    @State private var titleAppears = false
    
    private let animation = Animation.bouncy(duration: 2)
    
    let posts = [
        Post(title: "Title of Post 1", type: "Question", username: "teckenrod"),
        Post(title: "Title of Post 2", type: "Design", username: "cwilmot"),
        Post(title: "Title of Post 3", type: "Post", username: "memenster"),
        Post(title: "Title of Post 4", type: "Launch", username: "tpawlenty")
    ]

    var body: some View {
        NavigationStack {
            
            List {
                ForEach(posts) { post in
                    Section {
                        PostDetailView(post: post)
                        NavigationLink("Go To Post", value: post)
                    }
                }
            }
            .navigationDestination(for: Post.self) { post in
                    PostDetailView(post: post)
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
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
                            
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color("TextColor"))
                    }
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    
                    Spacer()
                    
                    Image(systemName: "aqi.medium")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("TextColor"))
                        .opacity(1)
                    
                    Spacer()
                    
                    NavigationLink(destination: DistanceMeasureView()) {
                        Image(systemName: "scope")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("TextColor"))
                            .opacity(0.4)
                    }
                        
                    Spacer()
                    
                    NavigationLink(destination: DeviceConnectionView()) {
                        Image(systemName: "location.north.line.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("TextColor"))
                            .opacity(0.4)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("TextColor"))
                            .opacity(0.4)
                    }
                    
                    Spacer()
                }
            }
        }
        .tint(Color("TextColor"))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PostsView()
        .modelContainer(for: Post.self, inMemory: true)
}
