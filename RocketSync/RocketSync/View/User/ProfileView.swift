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
    var userName: String
    
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
                            PostDetailView(post: post)
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
            }
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
