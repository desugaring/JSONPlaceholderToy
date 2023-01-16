//
//  Models.swift
//  JSONPlaceholderToy
//
//  Created by Alex Semenikhine on 2023-01-12.
//

import Foundation

struct Post: Codable {
    
    var userId: Int
    var id: Int
    var title: String
    var body: String
}

struct Comment: Codable {
    
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}

struct User: Codable {
    
    var id: Int
    var name: String
    var email: String
    // TODO: fill the rest of the info given enough time
    
    static var dummyUser: User {
        return User(id: 1, name: "", email: "")
    }
}

