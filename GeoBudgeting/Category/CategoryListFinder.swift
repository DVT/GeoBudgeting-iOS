//
//  CategoryListFinder.swift
//  GeoBudgeting
//
//  Created by Zaheer Moola on 2019/05/06.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

class CategoryListFinder {
    
    
    func getCategories(storeName: String, completionHandler: @escaping ([String]) -> Void) {
        guard let encodedStoreName = storeName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        let url : String = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(encodedStoreName)&key=\(getAPIKey())"
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        
        let searchURL: URL = URL(string: url)!
        
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: searchURL) { data, response, error in
            defer {dataTask = nil}
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(Json4Swift_Base.self, from: data!)
                guard let categories = responseModel.results?[0].types else {
                    return
                }
                completionHandler(categories)
            } catch let error as NSError {
                print(error)
                print("Error")
            }
            
        }
        dataTask?.resume()
    }
}
