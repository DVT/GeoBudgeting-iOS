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
            let currentAmount: Double = datasnapshot.value as! Double
            let updatedAmount: Double = currentAmount + amount
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

}
