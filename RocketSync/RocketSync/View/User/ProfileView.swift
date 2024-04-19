//
//  ProfileView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    var postController: PostsController
    @State private var isCreatePostViewPresented = false
    @State var selection : Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                if selection == 0 {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 150)
                            .padding(.all)
                            .foregroundColor(Color("TextColor"))
                        
                        VStack {
                            Text(Auth.auth().currentUser?.displayName ?? "Name")
                                .fontWeight(.bold)
                                .foregroundColor(Color("TextColor"))
                            Text(Auth.auth().currentUser?.email ?? "email")
                                .fontWeight(.light)
                                .foregroundColor(Color("TextColor"))
                        }
                        
                        Spacer()
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.selection = 0
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
                
                switch selection {
                case 0:
                    List {
                        ForEach(postController.getUserPosts()) { post in
                            Section {
                                PostDetailView(post: post, expanded: false)
                            }
                        }
                    }
                    
                case 1:
                    List {
                        ForEach(postController.getUserPosts(type: "post")) { post in
                            Section {
                                PostDetailView(post: post, expanded: false)
                            }
                        }
                    }
                    
                case 2:
                    List {
                        ForEach(postController.getUserPosts(type: "question")) { post in
                            Section {
                                PostDetailView(post: post, expanded: false)
                            }
                        }
                    }
                    
                case 3:
                    List {
                        ForEach(postController.getUserPosts(type: "launches")) { post in
                            Section {
                                PostDetailView(post: post, expanded: false)
                            }
                        }
                    }
                    
                case 4:
                    List {
                        ForEach(postController.getUserPosts(type: "designs")) { post in
                            Section {
                                PostDetailView(post: post, expanded: false)
                            }
                        }
                    }
                    
                default:
                    Spacer()
                }
                
                Button(action: {
                    isCreatePostViewPresented.toggle()
                }) {
                    Text("Create Post")
                        .padding()
                        .foregroundStyle(.tint)
                        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(.tint, lineWidth: 2))
                        .foregroundColor(Color("TextColor"))
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
            }
        }
    }
}

#Preview {
    ProfileView(postController: PostsController())
}
