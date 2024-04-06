//
//  AddPostView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/12/24.
//

import SwiftUI
import PhotosUI
import SwiftData
import FirebaseAuth

struct CreatePostView: View {
    @State private var postTitle: String = ""
    @State private var postType: PostType = .post
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var postPhoto: Data?
    @Environment(\.presentationMode) var presentationMode
    
    enum PostType: String, CaseIterable, Identifiable {
        case post, question, design, launch
        var id: Self { self }
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Image(systemName: "text.justify")
                    .padding(.leading)
                
                Text("Title: ")
                    .frame(width: 150, alignment: .leading)
                    .foregroundColor(Color("TextColor"))

                Spacer()
                
                TextField("Enter Title", text: $postTitle)
            }
            
            HStack {
                Image(systemName: "filemenu.and.selection")
                    .padding(.leading)
                
                Text("Type: ")
                    .frame(width: 150, alignment: .leading)
                    .foregroundColor(Color("TextColor"))

                Picker("Type", selection: $postType) {
                    ForEach(PostType.allCases) { type in
                        Text(type.rawValue.capitalized)
                            .foregroundColor(Color("TextColor"))
                    }
                }
                
                Spacer()
            }
            
            HStack {
                Image(systemName: "photo")
                    .padding(.leading)
                
                Text("Photo: ")
                    .frame(width: 150, alignment: .leading)
                    .foregroundColor(Color("TextColor"))

                PhotosPicker("Add Image", selection: $selectedPhoto,matching: .images, photoLibrary: .shared())
                    .foregroundColor(Color("TextColor"))
                
                Spacer()
            }
            
//            if postPhoto != nil {
//                PostDetailView(post: Post(id: "", title: postTitle, type: postType.rawValue.capitalized, user: Auth.auth().currentUser?.displayName, likes: 0, comments: []))
//                    .padding(.all)
//            } else {
//                PostDetailView(post: Post(id: "", title: postTitle, type: postType.rawValue.capitalized, user: Auth.auth().currentUser?, likes: 0, comments: []))
//                    .padding(.all)
//            }
            
            Spacer()
            
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                postPhoto = data
            }
        }
        
        Button {
            PostsController().addPost(title: postTitle, type: postType.rawValue, user: Auth.auth().currentUser?.displayName! ?? "")
            self.presentationMode.wrappedValue.dismiss()
            
        } label: {
            Image(systemName: "plus.rectangle")
                .resizable()
                .foregroundColor(Color("TextColor"))
                .scaledToFit()
                .frame(height: 50)
        }

    }
}

#Preview {
    CreatePostView()
}
