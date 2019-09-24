//
//  Results.swift
//  GeoBudgeting
//
//  Created by Zaheer Moola on 2019/05/09.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
struct Results : Codable {
    let formatted_address : String?
    let geometry : Geometry?
    let icon : String?
    let id : String?
    let name : String?
    let place_id : String?
    let rating : Double?
    let reference : String?
    let types : [String]?
    let user_ratings_total : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case formatted_address = "formatted_address"
        case geometry = "geometry"
        case icon = "icon"
        case id = "id"
        case name = "name"
        case place_id = "place_id"
        case rating = "rating"
        case reference = "reference"
        case types = "types"
        case user_ratings_total = "user_ratings_total"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        formatted_address = try values.decodeIfPresent(String.self, forKey: .formatted_address)
        geometry = try values.decodeIfPresent(Geometry.self, forKey: .geometry)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        place_id = try values.decodeIfPresent(String.self, forKey: .place_id)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
        types = try values.decodeIfPresent([String].self, forKey: .types)
        user_ratings_total = try values.decodeIfPresent(Double.self, forKey: .user_ratings_total)
    }
    
}
