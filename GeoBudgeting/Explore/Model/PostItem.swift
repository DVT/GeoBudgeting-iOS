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
    let category: String
    let mapLatitude: Double
    let mapLongitude: Double
    init(category: String, mapLatitude: Double,
         mapLongitude: Double,
         key: String = "") {
        self.ref = nil
        self.key = key
        self.category = category
        self.mapLatitude = mapLatitude
        self.mapLongitude = mapLongitude
    }
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let category = value["category"] as? String,
            let mapLatitude = value["mapLatitude"] as? Double,
            let mapLongitude = value["mapLongitude"] as? Double
            else {
                return nil
        }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.category = category
        self.mapLatitude = mapLatitude
        self.mapLongitude = mapLongitude
    }
    func toAnyObject() -> Any {
        return [
            "category": category,
            "mapLatitude": mapLatitude,
            "mapLongitude": mapLongitude
        ]
    }
}
