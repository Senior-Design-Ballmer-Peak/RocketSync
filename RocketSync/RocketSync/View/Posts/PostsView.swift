//
//  ContentView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI

struct PostsView: View {
    var postController: PostsController
    @State private var posts: [Post] = []
    @State private var selectedPost: Post?
    @State private var isPostDetailViewPresented = false

    
    var body: some View {
        VStack {
            List {
                ForEach(posts) { post in
                    Section {
                        Button {
                            selectedPost = post
                            isPostDetailViewPresented.toggle()
                        } label: {
                            PostDetailView(post: post)
                        }
                    }
                }
            }
        }
        .onAppear {
            posts = postController.getAllPosts()
        }
        .refreshable {
            posts = postController.getAllPosts()
        }
        .sheet(isPresented: $isPostDetailViewPresented, content: {
            VStack {
                PostDetailView(post: selectedPost ?? Post(id: "", title: "", type: "", text: "", user: "", likes: 0, commentText: [], commentUsers: []), expanded: true)
                    .padding()
                    .cornerRadius(20)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.automatic)
        })
    }
}

#Preview {
    PostsView(postController: PostsController())
}
