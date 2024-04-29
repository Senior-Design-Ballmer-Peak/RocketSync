//
//  Post.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/12/24.
//

import Foundation

struct Post: Identifiable, Hashable {
    
    var id: String
    var title: String
    var type: String
    var text: String
    var photoURL: String?
    var user: String
    var likes: Int
    var commentText: [String]
    var commentUsers: [String]
}
