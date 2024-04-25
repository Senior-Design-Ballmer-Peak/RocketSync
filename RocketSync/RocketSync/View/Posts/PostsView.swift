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
    @State private var isFilterPresented = false
    @State private var filterType: FilterType = .all
    
    enum FilterType: String, CaseIterable, Identifiable {
        case post, question, design, launch, all
        var id: Self { self }
    }

    
    var body: some View {
        ZStack {
            VStack {
                List {
                    
                    HStack {
                        Picker("Filter", selection: $filterType) {
                            ForEach(FilterType.allCases) { type in
                                Text(type.rawValue.capitalized)
                                    .foregroundColor(Color("TextColor"))
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
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
                        .background(RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(.secondary, lineWidth: 5)
                        )
                    }
                }.listStyle(.inset)
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isCreatePostViewPresented.toggle()
                    }) {
                        Text("Create Post")
                            .padding()
                            .foregroundStyle(Color("TextColor"))
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color("TextColor"), lineWidth: 5)
                                    .background(Color("BackgroundColor"))
                                    .opacity(0.8)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isFilterPresented.toggle()
                    }) {
                        Text("Filter")
                            .padding()
                            .foregroundStyle(Color("TextColor"))
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color("TextColor"), lineWidth: 5)
                                    .background(Color("BackgroundColor"))
                                    .opacity(0.8)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                    
                    Spacer()
                }
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
