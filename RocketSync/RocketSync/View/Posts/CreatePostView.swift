//
//  AddPostView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/12/24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct CreatePostView: View {
    @State private var postTitle: String = ""
    @State private var postType: PostType = .post
    @State private var postUsername: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var postPhoto: Data?
    
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
                Image(systemName: "person.circle")
                    .padding(.leading)
                    .foregroundColor(Color("TextColor"))

                Text("Username: ")
                    .frame(width: 150, alignment: .leading)
                    .foregroundColor(Color("TextColor"))
                
                Spacer()
                
                TextField("Enter Username", text: $postUsername)
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
            
            if let postPhoto {
                PostDetailView(post: Post(title: postTitle, type: postType.rawValue.capitalized, username: postUsername, photo: postPhoto))
                    .padding(.all)
            } else {
                PostDetailView(post: Post(title: postTitle, type: postType.rawValue.capitalized, username: postUsername))
                    .padding(.all)
            }
            
            Spacer()
            
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                postPhoto = data
            }
        }
        
        Button {
            do {
                if postType == PostType.post {
                    if let photo = postPhoto {
                        try? Post(title: postTitle, type: postType.rawValue, username: postUsername, photo: photo).modelContext?.save()
                    }
                } else {
                    try Post(title: postTitle, type: postType.rawValue, username: postUsername).modelContext?.save()
                }
            } catch {
                print("Post not saved")
            }
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
