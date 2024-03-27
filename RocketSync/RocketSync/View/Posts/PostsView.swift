//
//  ContentView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI

struct PostsView: View {
    let posts: [Post] = []/*PostsController().getPosts()*/
    
    var body: some View {
        BaseView(selectedTab: 0)
        NavigationStack {
            
            List {
                ForEach(posts) { post in
                    Section {
                        PostDetailView(post: post)
                    }
                }
            }
            
        }
    }
}

#Preview {
    PostsView()
}
