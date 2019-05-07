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

struct Tab {
    let tabIndex: Int!
    let tabName: String!
    let tabNavName: String!
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
//        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
//        let initialViewController = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsNav")
//        initialViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        tabController.viewControllers?.remove(at: tabIndex)
//        tabController.viewControllers?.append(initialViewController)
//        tabController.selectedViewController = initialViewController
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
