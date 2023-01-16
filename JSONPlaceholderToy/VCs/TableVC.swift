//
//  TableVC.swift
//  JSONPlaceholderToy
//
//  Created by Alex Semenikhine on 2023-01-11.
//

import UIKit
import Combine

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    let dataStore = DataStore.shared
    var cancellable: Cancellable?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        cancellable = dataStore.posts.publisher(for: \.status).dropFirst(1).receive(on: RunLoop.main).sink { [weak self] status in
            guard let self else { return }
            if status != .loading {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        if let path = tableView.indexPathForSelectedRow {

            tableView.deselectRow(at: path, animated: true)
        }
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        
        Task {
            await dataStore.posts.fetch(forceFetch: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.sortedPosts.count
    }
    
    @IBAction func clearUnfavored(_ sender: Any) {
        dataStore.removeUnfavoredPosts()
        self.tableView.reloadData()
    }
    
    @IBAction func favorPost(_ sender: UIButton) {
        if sender.isSelected {
            dataStore.unfavorPost(postId: sender.tag)
        }
        else {
            dataStore.favorPost(postId: sender.tag)
        }
        
        sender.isSelected = !sender.isSelected
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = dataStore.sortedPosts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostCell
        
        let isFavored = dataStore.favoritePostIds.contains(item.id)
        
        cell.textfield.text = item.title
        cell.button.isSelected = isFavored
        cell.button.tag = item.id
        
        return cell
    }
    
    // deleting items
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedPost = dataStore.sortedPosts[indexPath.row]
            dataStore.posts.value!.removeAll(where: { $0.id == selectedPost.id })
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailVC else { fatalError() }
        
        let selectedRow = tableView.indexPathForSelectedRow!.row
        let selectedPost = dataStore.sortedPosts[selectedRow]
        
        detailVC.title = selectedPost.title
        detailVC.post = selectedPost
    }


}

