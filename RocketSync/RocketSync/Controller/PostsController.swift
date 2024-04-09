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
    
    func getPosts() {
        db.collection("Posts").order(by: "type").addSnapshotListener { (querySnapshot, error) in
            if let e = error {
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
        print("\(Auth.auth().currentUser?.displayName ?? "Name") liked the post: \(post.title)")
    }
    
    func addComment(post: Post, comment: String) {
        print("\(Auth.auth().currentUser?.displayName ?? "Name") commented '\(comment)' on post: \(post.title)")
    }
    
    func getUserPosts(type: String = "all") -> [Post] {
        print("Posts user: \(posts.count)")
        getPosts()
        return posts.filter { post in
            if (type == "all") {
                post.user == Auth.auth().currentUser?.displayName
            } else {
                post.user == Auth.auth().currentUser?.displayName && post.type == type
            }
        }
    }
    
    func getAllPosts(type: String = "all") -> [Post] {
        print("Posts all: \(posts.count)")
        getPosts()
        if (type == "all") {
            return posts
        } else {
            return posts.filter { post in
                post.type == type
            }
        }
    }
    
    
}
