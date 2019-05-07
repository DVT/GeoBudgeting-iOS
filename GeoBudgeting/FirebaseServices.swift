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
    
    func addNewItem(storeName: String, storeCategory: String, dateTime: String, amount: String) {
        let ref: DatabaseReference = Database.database().reference()
        ref.child("receipts/\(storeName)/category").setValue(storeCategory)
        ref.child("receipts/\(storeName)/date/\(dateTime)").setValue(amount)
    }
}