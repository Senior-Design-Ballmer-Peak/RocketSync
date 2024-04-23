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
    @State private var postText: String = ""
    @State private var postType: PostType = .post
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var postPhoto: Data?
    @Environment(\.presentationMode) var presentationMode
    
    enum PostType: String, CaseIterable, Identifiable {
        case post, question, design
        var id: Self { self }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Picker("Type", selection: $postType) {
                ForEach(PostType.allCases) { type in
                    Text(type.rawValue.capitalized)
                        .foregroundColor(Color("TextColor"))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.all)
            
            switch postType {
            case .design:
                PostInputField(title: "Title:", placeholder: "Enter Title", text: $postTitle)
                PostInputField(title: "Description:", placeholder: "Enter Description", text: $postText)
                HStack {
                    Image(systemName: "photo")
                        .padding(.leading)
                    
                    Text("Photo: ")
                        .frame(width: 150, alignment: .leading)
                        .foregroundColor(Color("TextColor"))
                    
                    PhotosPicker("Add Image", selection: $selectedPhoto, matching: .images, photoLibrary: .shared())
                        .foregroundColor(Color("TextColor"))
                    
                    Spacer()
                }.padding(.all)
            case .question:
                PostInputField(title: "Question:", placeholder: "Enter Question", text: $postTitle)
                PostInputField(title: "Detail:", placeholder: "Enter Detail", text: $postText)
            case .post:
                PostInputField(title: "Title:", placeholder: "Enter Title", text: $postTitle)
                PostInputField(title: "Description:", placeholder: "Enter Description", text: $postText)
            }
            
            Spacer()
            
            Button {
                addPost()
            } label: {
                Image(systemName: "plus.rectangle")
                    .resizable()
                    .foregroundColor(Color("TextColor"))
                    .scaledToFit()
                    .frame(height: 50)
            }
            .padding(.all)
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                postPhoto = data
            }
        }
    }
    
    private func addPost() {
        PostsController().addPost(title: postTitle, type: postType.rawValue, text: postText)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    struct PostInputField: View {
        let title: String
        let placeholder: String
        @Binding var text: String
        
        var body: some View {
            HStack {
                Image(systemName: "text.justify")
                    .padding(.leading)
                Text(title)
                    .frame(width: 150, alignment: .leading)
                    .foregroundColor(Color("TextColor"))
                Spacer()
                TextField(placeholder, text: $text)
                    .foregroundColor(Color("TextColor"))
            }
            .padding(.all)
        }
    }
}

#Preview {
    CreatePostView()
}
