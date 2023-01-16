//
//  CommentCell.swift
//  JSONPlaceholderToy
//
//  Created by Alex Semenikhine on 2023-01-12.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var body: UILabel!
    
    func setupWithComment(comment: Comment) {
        self.name.text = "name: \(comment.name)"
        self.email.text = "email: \(comment.email)"
        self.body.text = comment.body
    }
}
