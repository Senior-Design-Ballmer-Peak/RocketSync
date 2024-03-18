//
//  PostsViewController.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/13/24.
//

import Foundation
import Firebase
import FirebaseAuth

class PostsController {
    let db = Firestore.firestore()
    var posts: [Post] = []
    
    func loadPosts() {
        db.collection("Posts").order(by: "type").addSnapshotListener { (querySnapshot, error) in
            self.posts = []
            
            if let e = error {
                print("Error loading posts: \(e)")
            } else {
                if let snapshotDocs = querySnapshot?.documents {
                    for doc in snapshotDocs {
                        let data = doc.data()
                        if let postTitle = data["title"] as? String,
                           let postType = data["type"] as? String,
                           let postUser = data["user"] as? String {
                            let newPost = Post(id: doc.documentID, title: postTitle, type: postType, user: postUser)
                            self.posts.append(newPost)
                        }
                    }
                }
            }
        }
    }
    
    func addPost(title: String, type: String, user: String) {
        let doc: [String: Any] = [
            "title": title,
            "type": type,
            "user": user
        ]
        
        db.collection("Posts").addDocument(data: doc) { err in
            if let e = err {
                print("Error adding post: \(e)")
            } else {
                print("Successfully added post")
            }
        }
    }
    
    func getPosts() -> [Post] {
        loadPosts()
        return posts
    }
}
