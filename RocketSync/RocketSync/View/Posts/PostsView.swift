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
    
    var body: some View {
        NavigationStack {
            VStack {

                List {
                    ForEach(postController.getAllPosts()) { post in
                        Section {
                            PostDetailView(post: post)
                                .background(
                                    NavigationLink("", destination: PostDetailView(post: post, expanded: true))
                                            .opacity(0)
                                )
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PostsView(postController: PostsController())
}
