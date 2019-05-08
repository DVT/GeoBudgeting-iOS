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
    var activeField: UITextField?
    var scrollviewInsets: UIEdgeInsets?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up category picker
        categorySpinner.dataSource = self
        categorySpinner.delegate = self
        
        setupUI()
        
        registerForKeyboardNotifications()
        scrollviewInsets = self.scrollView.contentInset
    }
    
    func setupUI() {
        //set up add item button
        addItemButton.layer.borderWidth = 1
        addItemButton.layer.borderColor = UIColor.blue.cgColor
        addItemButton.layer.cornerRadius = 10
        
        //set up date picker
        datePicker.datePickerMode = UIDatePicker.Mode.date
        
        self.hideKeyboard()
    }
    
    @IBAction func addItemTapped(_ sender: Any) {
//        let storeName = storeNameTextField.text!
//        let category = storeCategories[selectedCategoryRow]
//        let stringAmount = priceEditText.text
//        let amount = Double(stringAmount!) ?? 0
//
//        let timestampString = getDateForStartOfDayAsString(fromDate: datePicker.date)
//
//        CategoryListFinder().getCategories(storeName: storeName){ categories, lat, long in
//
//            FirebaseServices().addNewItem(storeName: storeName,
//                                          storeCategory: category,
//                                          dateTime: timestampString,
//                                          amount: amount,
//                                          latitude: lat,
//                                          longitude: long )
//        }
        
        ocr()
        
    }
    
    
    @IBAction func amountTextFieldTapped(_ sender: Any) {
        self.activeField = self.priceEditText
        //registerForKeyboardNotifications()
    }
    
    
    @IBAction func storenameEditTextTapped(_ sender: Any) {
        self.activeField = self.priceEditText
        //registerForKeyboardNotifications()
    }
    
    
    @IBAction func storeNameEditingEnd(_ sender: Any) {
        deregisterFromKeyboardNotifications()
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

// MARK: Move view when keyboard opens
extension AddItemViewController {
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = true
        self.scrollView.contentInset = scrollviewInsets!
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
}


// MARK: Close keyboard on touch outside edit text
extension AddItemViewController {
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
