//
//  PostsViewController.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/13/24.
//

import Foundation
import Firebase
import FirebaseAuth

class PostsController: ObservableObject {
    let db = Firestore.firestore()
    @Published var posts: [Post] = []
    @Published var error: Error?
    
    func getPosts() {
        db.collection("Posts").order(by: "type").addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                self.error = e
                print("Error loading posts: \(e)")
                return
            }
            
            var fetchedPosts: [Post] = []
            
            if let snapshotDocs = querySnapshot?.documents {
                for doc in snapshotDocs {
                    let data = doc.data()
                    if let postTitle = data["title"] as? String,
                       let postType = data["type"] as? String,
                       let postUser = data["user"] as? String,
                       let postLikes = data["likes"] as? Int,
                       let postCommentText = data["commentText"] as? [String],
                       let postCommentUsers = data["commentUsers"] as? [String] {
                        let newPost = Post(id: doc.documentID, title: postTitle, type: postType, user: postUser, likes: postLikes, commentText: postCommentText, commentUsers: postCommentUsers)
                        fetchedPosts.append(newPost)
                    }
                }
                self.posts = fetchedPosts
            }
        }
    }
    
    func addPost(title: String, type: String, user: String) {
        let doc: [String: Any] = [
            "title": title,
            "type": type,
            "user": user,
            "likes": 0,
            "commentText": [],
            "commentUsers": []
        ]
        
        db.collection("Posts").addDocument(data: doc) { err in
            if let e = err {
                print("Error adding post: \(e)")
            } else {
                print("Successfully added post")
            }
        }
    }
    
    func addLike(post: Post) {
        
    }
}
