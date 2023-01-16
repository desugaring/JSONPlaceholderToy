//
//  AuthorCell.swift
//  JSONPlaceholderToy
//
//  Created by Alex Semenikhine on 2023-01-12.
//

import UIKit

class PostHeaderCell: UITableViewCell {
    
    @IBOutlet var authorName: UILabel!
    @IBOutlet var authorEmail: UILabel!
    @IBOutlet var postDescription: UILabel!
    
    func setup(author: User, post: Post) {
        self.authorName.text = "Author name: \(author.name)"
        self.authorEmail.text = "Author email: \(author.email)"
        self.postDescription.text = "Description: \(post.body)"
    }
}
