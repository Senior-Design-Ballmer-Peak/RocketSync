//
//  PostDetailView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI

struct PostDetailView: View {
    @StateObject private var postController = PostsController()
    var post: Post
    var expanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("TextColor"))
                    .padding(.leading)
                
                Text(post.user)
                    .foregroundColor(Color("TextColor"))
                
                Spacer()
                
                Text(post.type.prefix(1).uppercased() + post.type.dropFirst())
                    .padding(.trailing)
                    .foregroundColor(Color("TextColor"))
            }
            
            if let imageData = post.photo, let uiImage = UIImage(data: imageData) {
                
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()
            } else if post.type != "question" {
                
                Image("rocket")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()
            }
            
            Text(post.title)
                .foregroundColor(Color("TextColor"))
                .padding(.horizontal)
            
            if expanded {
                
                Divider()
                
                HStack {
                    Spacer()
                    Button(action: {
                        // Handle like action
                    }) {
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("TextColor"))
                    }
                    Text("\(post.likes)")
                        .foregroundColor(Color("TextColor"))
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle comment action
                    }) {
                        Image(systemName: "bubble.left")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("TextColor"))
                    }
                    
                    Text("\(post.commentText.count)")
                        .foregroundColor(Color("TextColor"))

                    Spacer()
                }
                .padding(.horizontal, 16)
                
                Divider()
            
                VStack {
                    ForEach(Array(zip(post.commentText, post.commentUsers)), id: \.0) { pair in
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20, alignment: .center)
                                .foregroundColor(Color("TextColor"))
                            Text(pair.1)
                                .foregroundColor(Color("TextColor"))
                            
                            Spacer()
                            
                            Text(pair.0)
                                .foregroundColor(Color("TextColor"))
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    PostDetailView(post: Post(id: "", title: "Preview", type: "Design", user: "teckenrod", likes: 3, commentText: ["nice", "looks good"], commentUsers: ["teckenrod", "tpawlenty"]), expanded: true)
}
