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
    
    func getPosts(completion: @escaping ([Post]) -> Void) {
        db.collection("Posts").order(by: "type").getDocuments { (querySnapshot, error) in
            if let e = error {
                print("Error loading posts: \(e)")
                completion([])
            }
            
            var fetchedPosts: [Post] = []
            

            for doc in querySnapshot!.documents {
                let data = doc.data()
                if let postTitle = data["title"] as? String,
                   let postType = data["type"] as? String,
                   let postUser = data["user"] as? String,
                   let postLikes = data["likes"] as? Int,
                   let postCommentText = data["commentText"] as? [String],
                   let postCommentUsers = data["commentUsers"] as? [String],
                   let postText = data["text"] as? String {
                    let newPost = Post(id: doc.documentID, title: postTitle, type: postType, text: postText, user: postUser, likes: postLikes, commentText: postCommentText, commentUsers: postCommentUsers)
                    fetchedPosts.append(newPost)
                }
            }
            completion(fetchedPosts.reversed())
        }
    }
    
    func addPost(title: String, type: String, text: String) {
        let doc: [String: Any] = [
            "title": title,
            "text": text,
            "type": type,
            "user": Auth.auth().currentUser?.displayName ?? "",
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
        let dbPost = db.collection("Posts").document(post.id)
        dbPost.updateData(["likes": post.likes + 1])
        
        print("\(Auth.auth().currentUser?.displayName ?? "Name") liked the post: \(post.title)")
    }
    
    func addComment(post: Post, comment: String) {
        let dbPost = db.collection("Posts").document(post.id)
        var comments = post.commentText
        var users = post.commentUsers
        dbPost.updateData(["commentText": comments.append(comment)])
        dbPost.updateData(["commentUser": users.append(Auth.auth().currentUser?.displayName ?? "Anonomous") ])
        
        print("\(Auth.auth().currentUser?.displayName ?? "Name") commented '\(comment)' on post: \(post.title)")
    }
}
