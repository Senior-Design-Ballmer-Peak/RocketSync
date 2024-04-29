//
//  PostsViewController.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/13/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class PostsController: ObservableObject {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
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
                    var newPost: Post
                    if let photURL = data["photoURL"] as? String {
                        newPost = Post(id: doc.documentID, title: postTitle, type: postType, text: postText, photoURL: photURL, user: postUser, likes: postLikes, commentText: postCommentText, commentUsers: postCommentUsers)
                    } else {
                        newPost = Post(id: doc.documentID, title: postTitle, type: postType, text: postText, user: postUser, likes: postLikes, commentText: postCommentText, commentUsers: postCommentUsers)
                    }
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
    
    func addPostWithPhoto(title: String, type: String, text: String, image: UIImage) {
        let photoFilename = UUID().uuidString + ".jpg"
        let photoRef = storage.reference().child("photos/\(photoFilename)")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to data")
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let _ = photoRef.putData(imageData, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                print("Error uploading photo: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let photoURL = photoRef.fullPath
            self.addPost(title: title, type: type, text: text, photoURL: photoURL)
        }
    }
    
    private func addPost(title: String, type: String, text: String, photoURL: String?) {
        var doc: [String: Any] = [
            "title": title,
            "text": text,
            "type": type,
            "user": Auth.auth().currentUser?.displayName ?? "",
            "likes": 0,
            "commentText": [],
            "commentUsers": []
        ]
        
        if let photoURL = photoURL {
            doc["photoURL"] = photoURL
        }
        
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
    
    func fetchImage(from imageURL: String, completion: @escaping (Data?) -> Void) {
        let storageRef = storage.reference(forURL: "gs://rocketsync-f1499.appspot.com/" + imageURL)
        
        let maxSizeBytes: Int64 = 5 * 1024 * 1024
        storageRef.getData(maxSize: maxSizeBytes) { data, error in
            if let error = error {
                print("Error downloading image from \(imageURL): \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(data)
            }
        }
    }
}
