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
    @IBOutlet weak var scrollView: UIScrollView!
    
    var storeCategories = ["Supermarket" , "Bakery"]
    var selectedCategoryRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up category picker
        categorySpinner.dataSource = self
        categorySpinner.delegate = self
        
        setupUI()
        
    }
    
    func setupUI() {
        //set up add item button
        addItemButton.layer.borderWidth = 1
        addItemButton.layer.borderColor = UIColor.blue.cgColor
        addItemButton.layer.cornerRadius = 10
        
        //set up date picker
        datePicker.datePickerMode = UIDatePicker.Mode.date
    }
    
    @IBAction func addItemTapped(_ sender: Any) {
        let storeName = storeNameTextField.text!
        let category = storeCategories[selectedCategoryRow]
        let stringAmount = priceEditText.text
        let amount = Double(stringAmount!) ?? 0

        let timestampString = getDateForStartOfDayAsString(fromDate: datePicker.date)
        
        CategoryListFinder().getCategories(storeName: storeName){ categories, lat, long in
            
            FirebaseServices().addNewItem(storeName: storeName,
                                          storeCategory: category,
                                          dateTime: timestampString,
                                          amount: amount,
                                          latitude: lat,
                                          longitude: long )
        }
    }
    
    func getDateForStartOfDayAsString(fromDate date: Date) -> String {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let timestamp = startOfDay.timeIntervalSince1970
        var timestampString = String(format:"%f", timestamp)
        let dotIndex = timestampString.firstIndex(of: ".")
        timestampString = String(timestampString.prefix(upTo: dotIndex!))
        return timestampString
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
