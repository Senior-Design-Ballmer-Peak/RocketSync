//
//  ProfileView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI

struct ProfileView: View {
    var postController: PostsController
    @State var selection : Int = 0
    @State private var posts: [Post] = []
    @State private var selectedPost: Post?
    @State private var isPostDetailViewPresented = false
    @State private var presentationDetent: PresentationDetent = .medium
    @State private var isDeleteAlertPresented = false
    @State private var postToDelete: Post?

    var userName: String
    var currentUser: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    if selection != 0 {
                        Spacer()
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 150)
                            .padding(selection == 0 ? .all : .vertical)
                            .foregroundColor(Color("TextColor"))
                    }
                    
                    Text(userName)
                        .fontWeight(.bold)
                        .foregroundColor(Color("TextColor"))
                    
                    if selection == 1 {
                        Text("- Posts")
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextColor"))
                    } else if selection == 2 {
                        Text("- Questions")
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextColor"))
                    } else if selection == 3 {
                        Text("- Lauches")
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextColor"))
                    }
                    else if selection == 4 {
                        Text("- Designs")
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextColor"))
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.selection = 0
                        fetchPosts()
                    }, label: {
                        Image(systemName: "figure.stand")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 30, alignment: .center)
                            .foregroundColor(Color("TextColor"))
                            .opacity(selection == 0 ? 1 : 0.4)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        self.selection = 1
                        fetchPosts(type: "post")
                    }, label: {
                        Image(systemName: "text.bubble")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 30, alignment: .center)
                            .foregroundColor(Color("TextColor"))
                            .opacity(selection == 1 ? 1 : 0.4)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        self.selection = 2
                        fetchPosts(type: "question")
                    }, label: {
                        Image(systemName: "person.fill.questionmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30, alignment: .center)
                            .foregroundColor(Color("TextColor"))
                            .opacity(selection == 2 ? 1 : 0.4)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        self.selection = 3
                        fetchPosts(type: "launch")
                    }, label: {
                        Image(systemName: "location.north.line.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30, alignment: .center)
                            .foregroundColor(Color("TextColor"))
                            .opacity(selection == 3 ? 1 : 0.4)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        self.selection = 4
                        fetchPosts(type: "design")
                    }, label: {
                        Image(systemName: "scale.3d")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30, alignment: .center)
                            .foregroundColor(Color("TextColor"))
                            .opacity(selection == 4 ? 1 : 0.4)
                    })
                    
                    Spacer()
                    
                }.padding(.all)
                
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
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                if currentUser {
                                    Button(role: .destructive) {
                                        postToDelete = post
                                        isDeleteAlertPresented = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(.secondary, lineWidth: 2)
                        )
                    }
                }
                .listStyle(.inset)
                .refreshable {
                    if selection == 1 {
                        fetchPosts(type: "post")
                    } else if selection == 2 {
                        fetchPosts(type: "question")
                    } else if selection == 3 {
                        fetchPosts(type: "launch")
                    } else if selection == 4 {
                        fetchPosts(type: "design")
                    } else {
                        fetchPosts()
                    }
                }
                .alert(isPresented: $isDeleteAlertPresented) {
                    Alert(
                        title: Text("Delete Post"),
                        message: Text("Are you sure you want to delete this post?"),
                        primaryButton: .destructive(Text("Delete")) {
                            // Delete the post from Firebase
                            if let post = postToDelete {
                                postController.deletePost(post) { success in
                                    if success {
                                        posts.removeAll { $0.id == post.id }
                                    } else {
                                        print("Failed to delete post.")
                                    }
                                }
                            }
                        },
                        secondaryButton: .cancel(Text("Cancel"))
                    )
                }
            }
            .sheet(isPresented: $isPostDetailViewPresented, content: {
                PostDetailView(post: selectedPost ?? Post(id: "", title: "", type: "", text: "", user: "", likes: 0, commentText: "", commentUsers: ""), expanded: true)
                .cornerRadius(25)
                .padding(.init(top: 30, leading: 0, bottom: 10, trailing: 0))
                .presentationDetents([.large, .medium])
                .presentationDetents([.medium, .large], selection: $presentationDetent)
                .presentationDragIndicator(.automatic)
            })
        }
    }
    
    func fetchPosts(type: String = "all") {
        postController.getPosts { fetchedPosts in
            if (type == "all") {
                posts = fetchedPosts.filter { post in
                    post.user == userName
                }
            } else {
                posts = fetchedPosts.filter { post in
                    post.type == type && post.user == userName
                }
            }
        }
    }
}

#Preview {
    ProfileView(postController: PostsController(), userName: "Trey Eckenrod")
}
