//
//  ContentView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI

struct PostsView: View {
    @State private var titleAppears = false
    
    private let animation = Animation.bouncy(duration: 2)
    
//    let posts: [Post] = PostsController().getPosts()
    let posts = [
        Post(id: "1", title: "Test Launch 1", type: "Launch", user: "teckenrod"),
        Post(id: "2", title: "Test Launch 2", type: "Question", user: "cwilmot"),
        Post(id: "3", title: "Test Launch 3", type: "Post", user: "tpawlenty"),
        Post(id: "4", title: "Test Launch 4", type: "Design", user: "mmenster")
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
}
