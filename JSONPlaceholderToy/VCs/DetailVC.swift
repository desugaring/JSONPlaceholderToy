//
//  DetailVC.swift
//  JSONPlaceholderToy
//
//  Created by Alex Semenikhine on 2023-01-11.
//

import UIKit
import Combine

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var post: Post!
    var comments: LazyObject<[Comment]>!
    var author: User? = nil
    var cancellable: Cancellable?
    
    @IBOutlet var tableView: UITableView!
    
    let dataStore = DataStore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        title = post.title
        
        self.comments = dataStore.commentsForPost(postId: post.id)
        self.author = dataStore.authorForPost(postId: post.id)

        if self.comments.status != .loaded {
            Task {
                await self.comments.fetch()
            }
            cancellable = comments.publisher(for: \.status).dropFirst(1).receive(on: RunLoop.main).sink { [weak self] status in
                guard let self else { return }
                if status != .loading {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1 + (self.comments.value?.count  ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row
        {
        case 0:
            // header
            let cell = tableView.dequeueReusableCell(withIdentifier: "header_cell", for: indexPath) as! PostHeaderCell
            cell.setup(author: author ?? User.dummyUser, post: post)
            
            return cell
            
        default:
            // comment
            let item = self.comments.value![indexPath.row-1]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment_cell", for: indexPath) as! CommentCell
            cell.setupWithComment(comment: item)
            
            return cell
        }
    }
}
