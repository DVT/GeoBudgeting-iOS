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
    var dateArray = [String]()
    var moneySpent = 0.0

    var items: [PostItem] = []
    // MARK: Properties
   let ref = Database.database().reference(withPath: "receipts/\(userID)")
    let Dateref = Database.database().reference(withPath: "date/receipts")
    let postCell = PostCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Expenses"
        
        self.tableView.rowHeight = 75
        self.tableView.clipsToBounds = true
        tableView.allowsMultipleSelectionDuringEditing = false
//Get values from database
        if userID != "" {
            ref.queryOrdered(byChild: "date").observe(.value, with: { snapshot in
                var newItems: [PostItem] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let postItem = PostItem(snapshot: snapshot) {
                        var withinPeriod = false
                        Database.database().reference().child("receipts/\(userID)").child(postItem.key).child("date").observeSingleEvent(of: .value) { datasnapshot in
                            if datasnapshot.exists() {
                                for snap in datasnapshot.children.allObjects {
                                    if let snap = snap as? DataSnapshot {
                                        let date = snap.key
                                        let purchaseDate = self.getDateFromStamp(serverTimestamp: date)
                                        let currentDate = Date()
                                        let difference = currentDate.interval(ofComponent: .day, fromDate: purchaseDate)
                                        
                                        let selectedHistoryOptionIndex = UserDefaults.standard.integer(forKey: "history")
                                        var period = 0
                                        switch selectedHistoryOptionIndex {
                                        case 0: period = 30
                                        case 1: period = 60
                                        case 2: period = 90
                                        default:
                                            period = 0
                                        }
                                        
                                        if difference <= period {
                                            self.moneySpent = snap.value as! Double
                                            self.dateArray.append(date)
                                            withinPeriod = true
                                        }
                                    }
                                }
                                if withinPeriod {
                                    newItems.append(postItem)
                                }
                                self.items = newItems
                                self.tableView.reloadData()
                            }}}}})
        }
    }
    
    func getDateFromStamp(serverTimestamp: String) -> Date {
        let time = Int(serverTimestamp) ?? 0 / 1000
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        return date
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
        let postItem = items[indexPath.row]
        cell?.storeName?.text = postItem.key.capitalized
        cell?.category?.text = postItem.category
        
        if userID != "" {
            ref.observe(.value, with: { snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let postItem = PostItem(snapshot: snapshot) {
                        var amount = 0.00
                        let title = postItem.key
                        Database.database().reference().child("receipts/\(userID)").child(postItem.key).child("date").observeSingleEvent(of: .value) { datasnapshot in
                            if datasnapshot.exists() {
                                var keyArray = [String]()
                                for snap in datasnapshot.children.allObjects {
                                    if let snap = snap as? DataSnapshot {
                                        let date = snap.key
                                        let purchaseDate = self.getDateFromStamp(serverTimestamp: date)
                                        let currentDate = Date()
                                        let difference = currentDate.interval(ofComponent: .day, fromDate: purchaseDate)
                                        
                                        let selectedHistoryOptionIndex = UserDefaults.standard.integer(forKey: "history")
                                        var period = 0
                                        switch selectedHistoryOptionIndex {
                                        case 0: period = 30
                                        case 1: period = 60
                                        case 2: period = 90
                                        default:
                                            period = 0
                                        }
                                        
                                        if difference <= period {
                                            let moneySpent = snap.value
                                            amount += moneySpent as! Double
                                        }
                                        
                                        
                                        if ((cell?.storeName?.text)?.lowercased() == title) {
                                            let totalMoneySpent = String(format: "%.02f", amount)
                                            cell?.totalAmount?.text = "R" + String(totalMoneySpent)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storeName = items[indexPath.item].key
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let storePurchaseViewController: StorePurchasesViewController = mainStoryboard.instantiateViewController(withIdentifier: "StorePurcahsesViewController") as! StorePurchasesViewController
        storePurchaseViewController.storeName = storeName
        self.navigationController?.pushViewController(storePurchaseViewController, animated: true)
    }

}

func convertTimestamp(serverTimestamp: String) -> String {
    let time = Int(serverTimestamp) ?? 0 / 1000
    let date = NSDate(timeIntervalSince1970: TimeInterval(time))
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .medium
    return formatter.string(from: date as Date)
}

