//
//  Json4Swift_Base2.swift
//  GeoBudgeting
//
//  Created by Zaheer Moola on 2019/05/09.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

import Foundation
struct Json4Swift_Base2 : Codable {
    let results : [Results]?
    enum CodingKeys: String, CodingKey {
        
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
    }
    
}
