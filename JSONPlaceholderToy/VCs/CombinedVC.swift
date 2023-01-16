//
//  CombinedVC.swift
//  JSONPlaceholderToy
//
//  Created by Alex Semenikhine on 2023-01-12.
//

import UIKit

class CombinedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var dataStore: DataStore = DataStore.shared
    
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.sortedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TextCell
        
        cell.textfield.text = dataStore.sortedPosts[indexPath.row].title
        
        return cell
        
    }
    
    
    
    
    
}
