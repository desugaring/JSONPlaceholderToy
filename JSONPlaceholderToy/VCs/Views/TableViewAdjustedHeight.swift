//
//  CustomTableView.swift
//  JSONPlaceholderToy
//
//  Created by Alex Semenikhine on 2023-01-12.
//

import UIKit
class TableViewAdjustedHeight: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
