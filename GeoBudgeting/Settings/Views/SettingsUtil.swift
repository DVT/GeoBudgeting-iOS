//
//  UIImageExtention.swift
//  GeoBudgeting
//
//  Created by Divine Dube on 2019/05/10.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit
import GoogleSignIn


let USER_ID = "user"
let ID_TOKEN = "id_token"
let FULL_NAME = "full_name"
let GIVEN_NAME = "given_name"
let FAMILY_NAME = "family_name"
let EMAIL = "email"
let PROFILE_URL = "profile_url"


func makeUIImageViewCircle(imageView: UIImageView, imgSize: Int) {
    imageView.layer.cornerRadius = CGFloat(imgSize / 2)
    imageView.layer.masksToBounds = true;
}


func getSignedInUser() -> User? {
    //its a singleton so it does not matter how many times it gets called / hit stuff /
    //TODO : rename to userDefaults
    let pref = UserDefaults.standard
    
    let userId = pref.string(forKey: USER_ID) ?? ""
    // this means a user is not signed in yoh
    guard !userId.isEmpty else {
        return nil
    }
    
    let idToken = pref.string(forKey: ID_TOKEN)
    let fullName = pref.string(forKey: FULL_NAME)
    let givenName = pref.string(forKey: GIVEN_NAME)
    let familyName = pref.string(forKey: FAMILY_NAME)
    let email = pref.string(forKey: EMAIL)
    let profileURL = pref.string(forKey: PROFILE_URL)
    
    let user = User(userId: userId,
                    idToken: idToken,
                    fullName: fullName,
                    givenName: givenName,
                    familyName: familyName,
                    email: email,
                    profileURL: profileURL)
    
    return user
}

func routeToLogin(from view: UIViewController) {
//    let rootController = UIStoryboard(name: "Login",
//                                      bundle: Bundle.main)
//        .instantiateViewController(withIdentifier: "SignIn")
//        view.navigationController?.pushViewController(rootController, animated: true)
    
    let rootController = UIStoryboard(name: "Login",
                                      bundle: Bundle.main)
        .instantiateViewController(withIdentifier: "SignIn")
    view.view.window?.rootViewController = rootController
}

func logout() {
    let pref = UserDefaults.standard
    pref.removeObject(forKey: ID_TOKEN)
    pref.removeObject(forKey: FULL_NAME)
    pref.removeObject(forKey: GIVEN_NAME)
    pref.removeObject(forKey: FAMILY_NAME)
    pref.removeObject(forKey: PROFILE_URL)
    pref.removeObject(forKey: EMAIL)
    pref.synchronize()
    
    GIDSignIn.sharedInstance().signOut()
}


extension UIImageView {
    func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    return
            }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func dowloadFromServer(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {
            return
        }
        dowloadFromServer(url: url, contentMode: mode)
    }
}
