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
    @State private var imageData: Data?
    @State private var likes: Int = -1
    @State private var comment = ""
    @State private var isUserProfilelViewPresented = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: {
                    isUserProfilelViewPresented.toggle()
                }, label: {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("TextColor"))
                        .padding(.leading)
                })
                
                Text(post.user)
                    .foregroundColor(Color("TextColor"))
                
                Spacer()
                
                Text(post.type.prefix(1).uppercased() + post.type.dropFirst())
                    .padding(.trailing)
                    .foregroundColor(Color("TextColor"))
            }
            
            HStack {
                Spacer()
                if post.type == "design", let photoURL = post.photoURL {
                    if let imageData = imageData {
                        ImageView(imageData: imageData)
                            .padding(.horizontal)
                    } else {
                        ProgressView()
                            .onAppear {
                                postController.fetchImage(from: photoURL) { data in
                                    self.imageData = data
                                }
                            }
                    }
                }
                Spacer()
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
                        likes = post.likes + 1
                    }) {
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("TextColor"))
                    }
                    if likes == -1 {
                        Text("\(post.likes)")
                            .foregroundColor(Color("TextColor"))
                    } else {
                        Text("\(likes)")
                            .foregroundColor(Color("TextColor"))
                    }
                    
                    Spacer()
                    
//                    Button(action: {
//                        postController.addComment(post: post, comment: "Comment")
//                    }) {
//                        Image(systemName: "bubble.left")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(Color("TextColor"))
//                    }
                    
                    Image(systemName: "bubble.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("TextColor"))
                    Text("\(post.commentText.split(separator: ":::").count)")
                        .foregroundColor(Color("TextColor"))

                    Spacer()
                }
                .padding(.horizontal, 16)
                
                Divider()
                
                HStack {
                    TextField(text: $comment, prompt: Text("Enter Comment")) {
                        Image(systemName: "bubble.left")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("TextColor"))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        postController.addComment(post: post, comment: comment)
                        comment = ""
                    }) {
                        Image(systemName: "arrow.right.square")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("TextColor"))
                    }
                }
                .padding(.all)
            
                VStack {
                    if post.commentText.contains(":::") && post.commentUsers.contains(":::") {
                        ForEach(Array(zip(post.commentText.split(separator: ":::"), post.commentUsers.split(separator: ":::"))), id: \.0) { pair in
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
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $isUserProfilelViewPresented, content: {
            ProfileView(postController: postController, userName: post.user)
            .cornerRadius(25)
            .padding(.init(top: 30, leading: 0, bottom: 10, trailing: 0))
            .presentationDetents([.large])
            .presentationDragIndicator(.automatic)
        })
    }
}

struct ImageView: View {
    let imageData: Data
    
    var body: some View {
        Image(uiImage: UIImage(data: imageData) ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    PostDetailView(post: Post(id: "", title: "Preview", type: "Design", text: "Text", user: "teckenrod", likes: 3, commentText: "nice:::looks good", commentUsers: "teckenrod:::tpawlenty"), expanded: true)
}
