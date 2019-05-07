//
//  ExploreViewController.swift
//  GeoBudgeting
//
//  Created by Marie Kristein-Harmsen on 2019/05/06.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ExploreTableView: UITableViewController {
    var items: [PostItem] = []
    // MARK: Properties
   let ref = Database.database().reference(withPath: "receipts")
    let postCell = PostCell()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
        self.tableView.clipsToBounds = true
        tableView.allowsMultipleSelectionDuringEditing = false
//Get values from database
        ref.queryOrdered(byChild: "date").observe(.value, with: { snapshot in
            var newItems: [PostItem] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let postItem = PostItem(snapshot: snapshot) {
                                newItems.append(postItem)
                    }
                self.items = newItems
                self.tableView.reloadData()
            }})
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
        let postItem = items[indexPath.row]
        cell?.storeName?.text = postItem.key
        cell?.category?.text = postItem.category
//        cell?.date?.text = postItem.date
//        cell?.amount?.text = String(postItem.amount)
        return cell!
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postItem = items[indexPath.row]
            postItem.ref?.removeValue()
        }
    }
}

