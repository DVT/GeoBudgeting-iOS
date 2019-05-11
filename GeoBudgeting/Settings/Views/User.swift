//
//  User.swift
//  GeoBudgeting
//
//  Created by Divine Dube on 2019/05/10.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

class User: NSCoder {
    var userId: String? = "" {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(String(describing: newTotalSteps))")
        }
        didSet {
            
        }
    }
    var idToken: String?
    var fullName: String?
    var givenName: String?
    var familyName: String?
    var email: String?
    var profileURL: String?
    
    init(userId: String?, idToken: String?, fullName: String?, givenName: String?, familyName: String?, email: String?, profileURL: String?) {
        self.userId = userId
        self.idToken = idToken
        self.fullName = fullName
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
        self.profileURL = profileURL
    }
    
    //try this new property observers
    
    
}
