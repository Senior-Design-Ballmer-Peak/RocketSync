//
//  ContentView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI

struct PostsView: View {
    @EnvironmentObject var postController: PostsController
    @State private var posts: [Post] = []
    @State private var isLoading = false

    
    var body: some View {
        NavigationStack {
            VStack {

                List {
                    ForEach(posts) { post in
                        Section {
                            PostDetailView(post: post)
                                .background(
                                    NavigationLink("", destination: PostDetailView(post: post, expanded: true))
                                            .opacity(0)
                                )
                        }
                    }
                }
                .disabled(isLoading)
                .opacity(isLoading ? 0.5 : 1)
            }
            .onAppear {
                fetchPosts()
            }
        }
        .onChange(of: postController.posts, { oldValue, newValue in
            posts = newValue
            isLoading = false
        })
    }
        
    
    func fetchPosts() {
        isLoading = true
        postController.getPosts()
    }
}

#Preview {
    PostsView()
}
