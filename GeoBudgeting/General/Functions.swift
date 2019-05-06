//
//  Functions.swift
//  GeoBudgeting
//
//  Created by Prateek Kambadkone on 2019/05/06.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

struct API: Codable {
    let GoogleMapsAPI: String!
    
    enum CodingKeys: String, CodingKey {
        case GoogleMapsAPI = "GoogleMapsAPI"
    }
}

func getAPIKey() -> String {
    if  let path = Bundle.main.path(forResource: "api", ofType: "plist"),
        let xml = FileManager.default.contents(atPath: path),
        let key = try? PropertyListDecoder().decode(API.self, from: xml) {
        return key.GoogleMapsAPI
    }
    return ""
}
