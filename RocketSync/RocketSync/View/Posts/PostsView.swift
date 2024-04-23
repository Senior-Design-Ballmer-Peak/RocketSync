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
    @State private var presentationDetent: PresentationDetent = .medium
    @State private var isCreatePostViewPresented = false

    
    var body: some View {
        VStack {
            List {
                ForEach(posts) { post in
                    Section {
                        Button {
                            selectedPost = post
                            
                            if post.type == "question" {
                                presentationDetent = .medium
                            } else {
                                presentationDetent = .large
                            }
                            
                            isPostDetailViewPresented.toggle()
                        } label: {
                            PostDetailView(post: post)
                        }
                    }
                }
            }
            Button(action: {
                isCreatePostViewPresented.toggle()
            }) {
                Text("Create Post")
                    .padding()
                    .foregroundStyle(Color("TextColor"))
                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Color("TextColor"), lineWidth: 2))
            }
            
        }
        .sheet(isPresented: $isCreatePostViewPresented, content: {
            VStack {
                CreatePostView()
                    .padding()
                    .cornerRadius(20)
            }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.automatic)
        })
        .onAppear {
            posts = postController.getAllPosts()
        }
        .refreshable {
            posts = postController.getAllPosts()
        }
        .sheet(isPresented: $isPostDetailViewPresented, content: {
            PostDetailView(post: selectedPost ?? Post(id: "", title: "", type: "", text: "", user: "", likes: 0, commentText: [], commentUsers: []), expanded: true)
            .cornerRadius(25)
            .padding(.init(top: 30, leading: 0, bottom: 10, trailing: 0))
            .presentationDetents([.large, .medium])
            .presentationDetents([.medium, .large], selection: $presentationDetent)
            .presentationDragIndicator(.automatic)
        })
    }
}

#Preview {
    PostsView(postController: PostsController())
}
