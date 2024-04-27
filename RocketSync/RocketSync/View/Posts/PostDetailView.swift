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
                    .padding(.horizontal)
            } else if post.type == "launch" {
                Image("rocket")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()
                    .padding(.horizontal)
            }
            
            Text(post.title)
                .foregroundColor(Color("TextColor"))
                .padding(.horizontal)
            
            if expanded {
                Text(post.text)
                    .foregroundColor(Color("TextColor"))
                    .padding(.horizontal)
                
                Divider()
                
                HStack {
                    Spacer()
                    Button(action: {
                        postController.addLike(post: post)
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
                        postController.addComment(post: post, comment: "Comment")
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
    PostDetailView(post: Post(id: "", title: "Preview", type: "Design", text: "Text", user: "teckenrod", likes: 3, commentText: ["nice", "looks good"], commentUsers: ["teckenrod", "tpawlenty"]), expanded: true)
}
