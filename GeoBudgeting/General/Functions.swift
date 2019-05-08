//
//  Functions.swift
//  GeoBudgeting
//
//  Created by Prateek Kambadkone on 2019/05/06.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import UIKit

struct API: Codable {
    let GoogleMapsAPI: String!
    let OCRWebService: OCRWebService!
    
    enum CodingKeys: String, CodingKey {
        case GoogleMapsAPI = "GoogleMapsAPI"
        case OCRWebService = "OCRWebService"
    }
    
    struct OCRWebService: Codable {
        let username: String!
        let APIKey: String!
        
        enum CodingKeys: String, CodingKey {
            case username = "username"
            case APIKey = "APIKey"
        }
    }
}

func getGoogleAPIKey() -> String {
    if  let path = Bundle.main.path(forResource: "api", ofType: "plist"),
        let xml = FileManager.default.contents(atPath: path),
        let key = try? PropertyListDecoder().decode(API.self, from: xml) {
        return key.GoogleMapsAPI
    }
    return ""
}

func getOCRKey() -> (String, String) {
    if  let path = Bundle.main.path(forResource: "api", ofType: "plist"),
        let xml = FileManager.default.contents(atPath: path),
        let key = try? PropertyListDecoder().decode(API.self, from: xml) {
        return (key.OCRWebService.username, key.OCRWebService.APIKey)
    }
    return ("","")
}

func addTabs(tabIndex: Int, tabController: UITabBarController) {
    switch tabIndex {
    case 0:
        //        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        //        let initialViewController = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsNav")
        //        initialViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //        tabController.viewControllers?.remove(at: tabIndex)
        //        tabController.viewControllers?.append(initialViewController)
        //        tabController.selectedViewController = initialViewController
        return
    case 1:
        //        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        //        let initialViewController = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsNav")
        //        initialViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //        tabController.viewControllers?.remove(at: tabIndex)
        //        tabController.viewControllers?.append(initialViewController)
        //        tabController.selectedViewController = initialViewController
        return
    case 2:
                let addItemStoryboard = UIStoryboard(name: "AddItem", bundle: nil)
                let initialViewController = addItemStoryboard.instantiateViewController(withIdentifier: "AddItemNavigationController")
                initialViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                tabController.viewControllers?.remove(at: tabIndex)
                tabController.viewControllers?.append(initialViewController)
                tabController.selectedViewController = initialViewController
        return
    case 3:
        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        let initialViewController = settingsStoryboard.instantiateViewController(withIdentifier: "Settings")
        initialViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        tabController.viewControllers?.remove(at: tabIndex)
        tabController.viewControllers?.append(initialViewController)
        tabController.selectedViewController = initialViewController
    default:
        return
    }
}
