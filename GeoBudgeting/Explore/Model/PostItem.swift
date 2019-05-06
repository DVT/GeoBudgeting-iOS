//
//  PostItem.swift
//  GeoBudgeting
//
//  Created by Marie Kristein-Harmsen on 2019/05/06.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import Firebase

struct PostItem {
    let ref: DatabaseReference?
    let key: String
    let storeName: String
    let category: String
    let date: String
    let amount: Double
    init(storeName: String, category: String,
         date: String,
         amount: Double,
         key: String = "") {
        self.ref = nil
        self.key = key
        self.storeName = storeName
        self.category = category
        self.date = date
        self.amount = amount
    }
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let storeName = value["storeName"] as? String,
            let category = value["category"] as? String,
            let date = value["date"] as? String,
            let amount = value["amount"] as? Double
            else {
                return nil
        }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.storeName = storeName
        self.category = category
        self.date = date
        self.amount = amount
    }
    func toAnyObject() -> Any {
        return [
            "storeName": storeName,
            "category": category,
            "date": date,
            "amount": amount
        ]
    }
}
