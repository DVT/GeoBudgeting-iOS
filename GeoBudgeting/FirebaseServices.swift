//
//  FirebaseServices.swift
//  GeoBudgeting
//
//  Created by David Minders on 5/6/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseServices {
    
    func addNewItem(userID: String, storeName: String, storeCategory: String, dateTime: String, amount: Double, latitude: Double, longitude: Double) {
        let ref: DatabaseReference = Database.database().reference()
        ref.child("receipts/\(userID)/\(storeName)/category").setValue(storeCategory)
//        ref.child("receipts/\(userID)/\(storeName)/date/\(dateTime)").setValue(amount)
        ref.child("receipts/\(userID)/\(storeName)/mapLatitude").setValue(latitude)
        ref.child("receipts/\(userID)/\(storeName)/mapLongitude").setValue(longitude)
    
        ref.child("receipts/\(userID)/\(storeName)/date/\(dateTime)").observeSingleEvent(of: .value, with: { (datasnapshot) -> Void in
            if let datasnapshotValue = datasnapshot.value {
                let currentAmount: Double = datasnapshotValue as? Double ?? 0
                let updatedAmount: Double = currentAmount + amount
                ref.child("receipts/\(userID)/\(storeName)/date/\(dateTime)").setValue(updatedAmount)
            } else {
                ref.child("receipts/\(userID)/\(storeName)/date/\(dateTime)").setValue(amount)
            }
        })
    }
    
    func fetchAllPurchases(forUser userID: String, andforStore storeName: String, completion: @escaping ([Purchase]) -> Void) {
        var purchases: [Purchase] = [Purchase]()
        
        let ref: DatabaseReference = Database.database().reference()
        ref.child("receipts/\(userID)/\(storeName)/date").observeSingleEvent(of: .value, with: {(datasnapshot) in
            let children = datasnapshot.children
            for childSnapshot in children {
                let child = childSnapshot as! DataSnapshot
                let timestamp = child.key
                let date = convertTimestamp(serverTimestamp: timestamp)
                let amount = child.value! as! Double
                
                let purchase = Purchase(date: date, amount: amount)
                purchases.append(purchase)
                
                if purchases.count == datasnapshot.childrenCount {
                    completion(purchases)
                }
            }
            
        })
    }
    
    func fetchAllPurchasesListener(forUser userID: String, andForStore storeName: String, completion: @escaping ([Purchase]) -> Void) {
        var purchases: [Purchase] = [Purchase]()
        let ref: DatabaseReference = Database.database().reference()
        ref.child("receipts/\(userID)/\(storeName)/date").observe(.value, with: { (datasnapshot) -> Void in
            let children = datasnapshot.children
            for childSnapshot in children {
                let child = childSnapshot as! DataSnapshot
                let timestamp = child.key
                let date = convertTimestamp(serverTimestamp: timestamp)
                let amount = child.value! as! Double
                
                let purchase = Purchase(date: date, amount: amount)
                purchases.append(purchase)
                
                if purchases.count == datasnapshot.childrenCount {
                    completion(purchases)
                }
            }
        })
    }
    
    func fetchAllStoreAndPurchaseData(forUser userID: String, completion: @escaping ([Store]) -> Void) {
        var allData: [Store] = [Store]()
        let ref: DatabaseReference = Database.database().reference()
        ref.child("receipts/\(userID)").observe(.value, with: {(datasnapshot) in
            let storeChildren = datasnapshot.children
            for storeChild in storeChildren {
                let storeData: DataSnapshot = storeChild as! DataSnapshot
                
                var store = Store()
                store.storeName = storeData.key
                
                if let storeValue = storeData.value as? [String: AnyObject] {
                    var purcahses: [Purchase] = [Purchase]()
                    let purchasesInfo = storeValue["date"]
                    store.category = storeValue["category"] as! String
                    for purchase in purchasesInfo! as! [String: Double] {
                        let date = purchase.key
                        let amount = purchase.value
                        
                        purcahses.append(Purchase(date: date, amount: amount))
                    }
                    
                    store.purchases = purcahses
                    allData.append(store)
                }
                
            }
            completion(allData)
            
            
        })
    }
}
