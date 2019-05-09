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
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var historyPicker: UIPickerView!
    var selectedHistoryOptionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyPicker.delegate = self
        historyPicker.dataSource = self
        loadPreviousSettings()
    }
    
    @IBAction func saveCurrentChanges(_ sender: Any) {
        UserDefaults.standard.set(selectedHistoryOptionIndex, forKey: "history")
    }
    
    func loadPreviousSettings() {
        selectedHistoryOptionIndex = UserDefaults.standard.integer(forKey: "history")
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
        return historyOptions[row]
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedHistoryOptionIndex = row
    }
}
