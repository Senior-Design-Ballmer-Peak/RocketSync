//
//  Post.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/12/24.
//

import Foundation
import SwiftData

@Model
class Post: Identifiable {
    var id: String
    var title: String
    var type: String
    var photo: Data?
    var username: String

    
    init(title: String, type: String, username: String, photo: Data = Data()) {
        self.id = UUID().uuidString
        self.title = title
        self.type = type
        self.username = username
        self.photo = photo
    }
}
