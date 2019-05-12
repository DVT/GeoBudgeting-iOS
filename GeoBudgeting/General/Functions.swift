//
//  Functions.swift
//  GeoBudgeting
//
//  Created by Prateek Kambadkone on 2019/05/06.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

var userID: String {
    if GIDSignIn.sharedInstance()?.currentUser != nil {
        if let email = GIDSignIn.sharedInstance()?.currentUser.profile.email {
            let emailString = email.replacingOccurrences(of: ".", with: "_")
            return emailString
        } else {
            return ""
        }
    } else {
        return ""
    }
}

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
        initialViewController.tabBarItem.image = UIImage(named: "addItem")
        initialViewController.tabBarItem.selectedImage = UIImage(named: "addItem")
        initialViewController.tabBarItem.title = "Add Receipt"
        tabController.viewControllers?[tabIndex] = initialViewController
        tabController.selectedViewController = initialViewController
        
        return
    case 3:
        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        let initialViewController = settingsStoryboard.instantiateViewController(withIdentifier: "Settings")
        initialViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        initialViewController.tabBarItem.image = UIImage(named: "settings")
        initialViewController.tabBarItem.selectedImage = UIImage(named: "settings")
         initialViewController.tabBarItem.title = "Settings"
        tabController.viewControllers?[tabIndex] = initialViewController
        tabController.selectedViewController = initialViewController
    default:
        return
    }
}

class Functions {
    static var loginLodingIndicator: UIActivityIndicatorView?
    static var container: UIView?
    static var loadingView: UIView?
    
    static func showLoadingIndicator(mustShow: Bool, viewController: UIViewController) {
        
        if mustShow {
            container = UIView()
            container!.frame = viewController.view.frame
            container!.center = viewController.view.center
            container!.backgroundColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.7)
            
            loadingView = UIView()
            loadingView!.frame = CGRect(x: 0.0, y: 0.0, width: 80, height: 80)
            loadingView!.center = viewController.view.center
            loadingView!.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4)
            loadingView!.clipsToBounds = true
            loadingView!.layer.cornerRadius = 10
            
            loginLodingIndicator = UIActivityIndicatorView()
            loginLodingIndicator!.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 40)
            
            let frameWidth = loadingView!.frame.size.width
            let frameHeight = loadingView!.frame.size.height
            loginLodingIndicator?.center = CGPoint(x: frameWidth / 2, y: frameHeight / 2)
            loginLodingIndicator?.hidesWhenStopped = true
            loginLodingIndicator?.style = UIActivityIndicatorView.Style.whiteLarge
            loadingView!.addSubview(loginLodingIndicator!)
            container!.addSubview(loadingView!)
            viewController.view.addSubview(container!)
            loginLodingIndicator?.startAnimating()
        } else {
            DispatchQueue.main.async {
                container?.isHidden = true
                loadingView?.isHidden = true
                loginLodingIndicator?.stopAnimating()
                loginLodingIndicator = nil
            } 
        }
    }
}
