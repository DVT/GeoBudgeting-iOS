//
//  loginViewController.swift
//  GeoBudgeting
//
//  Created by Marie Kristein-Harmsen on 2019/05/09.
//  Copyright © 2019 DVT. All rights reserved.
//
import Foundation
import UIKit
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGoogleButton()
    }
    func setUpGoogleButton() {
        let googleButton = GIDSignInButton()
        googleButton.style = GIDSignInButtonStyle.wide
        self.view.addSubview(googleButton)
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       googleButton.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 24).isActive = true
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
}
