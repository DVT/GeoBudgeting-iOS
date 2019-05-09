//
//  Purchase.swift
//  GeoBudgeting
//
//  Created by David Minders on 5/9/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

struct Purchase {
    let date: String
    let amount: Double
    
    init(date: String, amount: Double) {
        self.date = date
        self.amount = amount
    }
}
