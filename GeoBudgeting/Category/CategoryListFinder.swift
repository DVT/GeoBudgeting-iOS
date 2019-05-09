//
//  CategoryListFinder.swift
//  GeoBudgeting
//
//  Created by Zaheer Moola on 2019/05/06.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

class CategoryListFinder {
    
    //Tel No Should be in format +27
    func getPlaceDetails(telNo: String, completionHandler: @escaping (String) -> Void) {
        guard let encodedTelNo = telNo.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved) else {
            return
        }
        
        let url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=\(encodedTelNo)&inputtype=phonenumber&key=\(getGoogleAPIKey())"
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        
        let searchURL: URL = URL(string: url)!
        
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: searchURL) { data, response, error in
            defer {dataTask = nil}
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(PlaceIdBase.self, from: data!)
                if responseModel.candidates?.count == 0 {
                    completionHandler("")
                }
                guard let placeId = responseModel.candidates?[0].place_id else {
                    print("Error getting Place ID")
                    return
                }
                completionHandler(placeId)
            } catch let error as NSError {
                print(error)
                print("Error")
            }
            
        }
        dataTask?.resume()
        
    }
    
    func getCategories(storeName: String, completionHandler: @escaping ([String], Double, Double) -> Void) {
        guard let encodedStoreName = storeName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        let url : String = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(encodedStoreName)&key=\(getGoogleAPIKey())"
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        
        let searchURL: URL = URL(string: url)!
        
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: searchURL) { data, response, error in
            defer {dataTask = nil}
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(Json4Swift_Base2.self, from: data!)
                guard let categories = responseModel.results?[0].types else {
                    return
                }
                guard let lat = responseModel.results?[0].geometry?.location?.lat else {
                    return
                }
                guard let long = responseModel.results?[0].geometry?.location?.lng else {
                    return
                }
                completionHandler(categories, lat, long)
            } catch let error as NSError {
                print(error)
                print("Error")
            }
            
        }
        dataTask?.resume()
        
    }
    
    func getCategories(telNo: String, completionHandler: @escaping ([String], String, Double, Double) -> Void) {
        
        getPlaceDetails(telNo: telNo) { placeId in
            if placeId.isEmpty {
                completionHandler([],"",0.0,0.0)
                
            } else {
                let url : String = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=\(getGoogleAPIKey())"
            
                let defaultSession = URLSession(configuration: .default)
                var dataTask: URLSessionDataTask?
            
                let searchURL: URL = URL(string: url)!
            
                dataTask?.cancel()
                dataTask = defaultSession.dataTask(with: searchURL) { data, response, error in
                    defer {dataTask = nil}
                    do {
                        let jsonDecoder = JSONDecoder()
                        let responseModel = try jsonDecoder.decode(Json4Swift_Base.self, from: data!)
                        guard let categories = responseModel.result?.types else {
                            return
                        }
                        guard let lat = responseModel.result?.geometry?.location?.lat else {
                            return
                        }
                        guard let long = responseModel.result?.geometry?.location?.lng else {
                            return
                        }
                        guard let storeName = responseModel.result?.name else {
                            return
                        }
                        completionHandler(categories, storeName, lat, long)
                    } catch let error as NSError {
                        print(error)
                        print("Error")
                    }
                    
                }
                dataTask?.resume()
            }
        }

    }
}

extension CharacterSet {
    static let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
}
