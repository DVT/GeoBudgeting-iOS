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
                        newItems.append(postItem)
                        Database.database().reference().child("receipts/\(userID)").child(postItem.key).child("date").observeSingleEvent(of: .value) { datasnapshot in
                            if datasnapshot.exists() {
                                for snap in datasnapshot.children.allObjects {
                                    if let snap = snap as? DataSnapshot {
                                        let date = snap.key
                                        self.moneySpent = snap.value as! Double
                                        self.dateArray.append(date)
                                        
                                    }
                                }
                                self.items = newItems
                                self.tableView.reloadData()
                            }}}}})
        }
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
                                        let key = snap.key
                                        let moneySpent = snap.value
                                        amount += moneySpent as! Double
                                        if ((cell?.storeName?.text)?.lowercased() == title){
                                            let totalMoneySpent = String(format: "%g", amount)
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

func summerizePurchases(completion: @escaping ([String: Double]) -> Void){
    var purchasesSummary = [String: Double]()
    FirebaseServices().fetchAllStoreAndPurchaseData(forUser: userID){allStoreData in
        
        for storeData in allStoreData {
            
            if purchasesSummary.index(forKey: storeData.category!) != nil {
                var currentAmount: Double = purchasesSummary[storeData.category!] ?? 0
                let storePurchases = storeData.purchases
                let storePurchaseAmount = storePurchases?.map{$0.amount}.reduce(0, +)
                currentAmount += storePurchaseAmount ?? 0
                purchasesSummary[storeData.category!] = (currentAmount)
                
            } else {
                let storePurchases = storeData.purchases
                let storePurchaseAmount = storePurchases?.map{$0.amount}.reduce(0, +)
                purchasesSummary[storeData.category!] = storePurchaseAmount
            }
        }
        completion(purchasesSummary)
    }
}

