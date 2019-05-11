//
//  SettingsViewController.swift
//  GeoBudgeting
//
//  Created by Prateek Kambadkone on 2019/05/07.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let historyOptions : [String] = ["last 30 days", "last 60 days", "last 90 days"]
    
    @IBOutlet weak var historyPicker: UIPickerView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var userProfileImg: UIImageView!
    
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyPicker.delegate = self
        historyPicker.dataSource = self
        user = getSignedInUser()
        loadPreviousSettings()
        
        guard user != nil else {
            //this should never happen
            return
        }
        
        nameLbl.text = user?.givenName
        emailLbl.text = user?.email
        makeUIImageViewCircle(imageView: userProfileImg, imgSize: 65)
        
        if let profileURL = user?.profileURL {
            userProfileImg.dowloadFromServer(link: profileURL)
        }
        
    }
    
    // save button
    func saveCurrentChanges(row: Int) {
        print("savedChanges \(row)")
      let pref = UserDefaults.standard
        pref.set(row, forKey: "history")
   //     pref.synchronize() // this method is unnecessry and should not be used!
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        logout()
        routeToLogin(from: self)
    }
    
    func loadPreviousSettings() {
        let selectedHistoryOptionIndex = UserDefaults.standard.integer(forKey: "history")
        historyPicker.selectRow(selectedHistoryOptionIndex, inComponent: 0, animated: true)
        print("historyOption:\(selectedHistoryOptionIndex)")
    }
    
    
}


extension SettingsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return historyOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        (pickerView.view(forRow: row, forComponent: component) as? UILabel)?.adjustsFontSizeToFitWidth = true
        return historyOptions[row]
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        saveCurrentChanges(row: row)
    }
}

