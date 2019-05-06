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
   // var items: [PostItem] = []
    // MARK: Properties
   // let ref = Database.database().reference(withPath: "recipets")
    let postCell = PostCell()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
        self.tableView.clipsToBounds = true
        tableView.allowsMultipleSelectionDuringEditing = false
    }
}
//Get values from database

//        let user = Auth.auth().currentUser
//
//        ref.queryOrdered(byChild: "timestamp").observe(.value, with: { snapshot in
//            var newItems: [PostItemTwo] = []
//            if self.ref.child("account") != user {
//                for child in snapshot.children {
//                    if let snapshot = child as? DataSnapshot,
//                        let postItem = PostItemTwo(snapshot: snapshot) {
//                        let user = Auth.auth().currentUser
//                        if user != nil {
//                            if postItem.account != self.currUser {
//                                newItems.append(postItem)
//                            }
//                        }
//                    }
//                }
//                self.items = newItems
//                self.tableView.reloadData()
//            }})

    // MARK: UITableView Delegate methods
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
////        let postItem = items[indexPath.row]
////        cell?.storeName?.text = postItem.storeName
////        cell?.category?.text = postItem.category
////        cell?.date?.text = postItem.date
////        cell?.amount?.text = postItem.amount
//        return cell!
//    }
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    override func tableView(_ tableView: UITableView,
//                            commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let postItem = items[indexPath.row]
//            postItem.ref?.removeValue()
//        }
//    }
//}

