//
//  PostTableView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 1/18/24.
//

import SwiftUI

struct Post: Identifiable {
    var id = UUID()
    var title: String
    var type: String
    var username: String
}

struct CustomPostCell: View {
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text(post.username)
                Spacer()
                Text(post.type)
            }
            Image("rocket")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .clipped()
            
            Text(post.title)
            
            Divider()
            
            HStack {
                Spacer()
                Button(action: {
                    // Handle like action
                }) {
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text("0")
                Spacer()
                Button(action: {
                    // Handle comment action
                }) {
                    Image(systemName: "bubble.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text("0")
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
    }
}

struct PostTableView: View {
    @State private var selectedOptions: Set<String> = ["Launch", "Post", "Question", "Design"]
    
    let posts = [
        Post(title: "Title of Post 1", type: "Question", username: "teckenrod"),
        Post(title: "Title of Post 2", type: "Design", username: "cwilmot"),
        Post(title: "Title of Post 3", type: "Post", username: "memenster"),
        Post(title: "Title of Post 4", type: "Launch", username: "tpawlenty")
    ]
    
    let filterOptions = ["Launch", "Post", "Question", "Design"]
    
    
    var body: some View {
        VStack {
            Menu {
                ForEach(filterOptions, id: \.self) { option in
                    Button(action: {
                        if selectedOptions.contains(option) {
                            selectedOptions.remove(option)
                        } else {
                            selectedOptions.insert(option)
                        }
                    }) {
                        HStack {
                            Text(option)
                            Spacer()
                            Image(systemName: selectedOptions.contains(option) ? "checkmark.circle" : "circle")
                        }
                    }
                }
            } label: {
                VStack(spacing: 5){
                    HStack{
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                            .font(Font.system(size: 20, weight: .bold))
                    }
                    .padding(.horizontal)
                }
            }
        
//                    Image(systemName: "line.3.horizontal.decrease.circle")
            
            
            List(posts) { post in
                CustomPostCell(post: post)
            }
            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
    }
}

#Preview {
    PostTableView()
}
