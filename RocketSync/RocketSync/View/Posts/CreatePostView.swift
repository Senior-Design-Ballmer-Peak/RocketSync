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
    @State private var postType: PostType = .select
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var postPhoto: Data?
    @Environment(\.presentationMode) var presentationMode
    
    enum PostType: String, CaseIterable, Identifiable {
        case post, question, design, select
        var id: Self { self }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()

                Picker("Type", selection: $postType) {
                    ForEach(PostType.allCases) { type in
                        Text(type.rawValue.capitalized)
                            .foregroundColor(Color("TextColor"))
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("TextColor"), lineWidth: 2)
                )
                
                Spacer()
            }.padding(.top)
            
            if postType == .design {
                
                HStack {
                    Image(systemName: "text.justify")
                        .padding(.leading)
                    
                    Text("Title: ")
                        .frame(width: 150, alignment: .leading)
                        .foregroundColor(Color("TextColor"))

                    Spacer()
                    
                    TextField("Enter Title", text: $postTitle)
                }.padding(.all)
                
                HStack {
                    Image(systemName: "text.justify")
                        .padding(.leading)
                    
                    Text("Description: ")
                        .frame(width: 150, alignment: .leading)
                        .foregroundColor(Color("TextColor"))

                    Spacer()
                    
                    TextField("Enter Description", text: $postText)
                }.padding(.all)
                
                HStack {
                    Image(systemName: "photo")
                        .padding(.leading)
                    
                    Text("Photo: ")
                        .frame(width: 150, alignment: .leading)
                        .foregroundColor(Color("TextColor"))
                    
                    PhotosPicker("Add Image", selection: $selectedPhoto,matching: .images, photoLibrary: .shared())
                        .foregroundColor(Color("TextColor"))
                    
                    Spacer()
                }.padding(.all)
                
            } else if postType == .question {
                HStack {
                    Image(systemName: "text.justify")
                        .padding(.leading)
                    
                    Text("Question: ")
                        .frame(width: 150, alignment: .leading)
                        .foregroundColor(Color("TextColor"))

                    Spacer()
                    
                    TextField("Enter Question", text: $postTitle)
                }.padding(.all)
                
                HStack {
                    Image(systemName: "text.justify")
                        .padding(.leading)
                    
                    Text("Detail: ")
                        .frame(width: 150, alignment: .leading)
                        .foregroundColor(Color("TextColor"))

                    Spacer()
                    
                    TextField("Enter Detail", text: $postText)
                }.padding(.all)
                
            } else if postType == .post {
                HStack {
                    Image(systemName: "text.justify")
                        .padding(.leading)
                    
                    Text("Title: ")
                        .frame(width: 150, alignment: .leading)
                        .foregroundColor(Color("TextColor"))

                    Spacer()
                    
                    TextField("Enter Title", text: $postTitle)
                }.padding(.all)
                
                HStack {
                    Image(systemName: "text.justify")
                        .padding(.leading)
                    
                    Text("Description: ")
                        .frame(width: 150, alignment: .leading)
                        .foregroundColor(Color("TextColor"))

                    Spacer()
                    
                    TextField("Enter Description", text: $postText)
                }.padding(.all)
            }
            
            Spacer()
            
            if postType != .select {
                Button {
                    PostsController().addPost(title: postTitle, type: postType.rawValue, text: postText)
                    self.presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Image(systemName: "plus.rectangle")
                        .resizable()
                        .foregroundColor(Color("TextColor"))
                        .scaledToFit()
                        .frame(height: 50)
                }.padding(.all)
            }
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                postPhoto = data
            }
        }
    }
}

//#Preview {
//    CreatePostView()
//}
