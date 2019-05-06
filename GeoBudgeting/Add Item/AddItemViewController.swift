//
//  AddItemViewController.swift
//  GeoBudgeting
//
//  Created by David Minders on 5/6/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var categorySpinner: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var priceEditText: UITextField!
    
    var storeCategories = ["Supermarket" , "Bakery"]
    var selectedCategoryRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set up add item button
        addItemButton.layer.borderWidth = 1
        addItemButton.layer.borderColor = UIColor.blue.cgColor
        addItemButton.layer.cornerRadius = 10
        
        //set up category picker
        categorySpinner.dataSource = self
        categorySpinner.delegate = self
        
    }
    
    @IBAction func addItemTapped(_ sender: Any) {
        let storeName = storeNameTextField.text!
        let category = storeCategories[selectedCategoryRow]
        let amount = priceEditText.text!
        
        FirebaseServices().addNewItem(storeName: storeName, storeCategory: category, dateTime: "New date", amount: amount)
    }
}

extension AddItemViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return storeCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return storeCategories[row]
    }
}

extension AddItemViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategoryRow = row
    }
}
