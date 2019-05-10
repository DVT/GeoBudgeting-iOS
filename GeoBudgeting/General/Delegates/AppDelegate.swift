//
//  AppDelegate.swift
//  GeoBudgeting
//
//  Created by Marie Kristein-Harmsen on 2019/05/03.
//  Copyright © 2019 DVT. All rights reserved.
//
import GoogleMaps
import GooglePlaces
import UIKit
import GoogleSignIn
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
    var window: UIWindow?
   override init() {
       FirebaseApp.configure()
       Database.database().isPersistenceEnabled = true
   }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Google sign in
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        //Userlogged in
        if Auth.auth().currentUser == nil {
            let rootController = UIStoryboard(name: "Login",
                                              bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "SignIn")
            self.window?.rootViewController = rootController
        } else {
            GIDSignIn.sharedInstance()?.signInSilently()
        }
        //Google Services
        GMSServices.provideAPIKey(getGoogleAPIKey())
        GMSPlacesClient.provideAPIKey(getGoogleAPIKey())
        return true
    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any])
        -> Bool {
            let googleAuthentication =
                GIDSignIn.sharedInstance().handle(url,
                                                  sourceApplication:
                    options[UIApplication.OpenURLOptionsKey.sourceApplication]
                        as? String, annotation: [:])
            return googleAuthentication
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Failed to log in with Google", error)
            return
        }
        print ("Successfully logged in with Google", user)
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (_, error) in
            if error != nil {
                return
            }
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "TabController")
            self.window?.rootViewController = homePage
        }
}
}

