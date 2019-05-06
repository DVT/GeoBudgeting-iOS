//
//  TabController.swift
//  GeoBudgeting
//
//  Created by Prateek Kambadkone on 2019/05/06.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class TabController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = tabBarController.selectedIndex
        if index == 3 {
            let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
            let initialViewController = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsNav")
            initialViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            tabBarController.viewControllers?.remove(at: index)
            tabBarController.viewControllers?.append(initialViewController)
            tabBarController.selectedViewController = initialViewController
            self.tabBar.items![3].selectedImage = UIImage(named: "icons8-services-filled-24")
            self.tabBar.items![3].image = UIImage(named: "icons8-services-filled-24")
            self.tabBar.items![3].title = "Settings"
        }
    }
}


