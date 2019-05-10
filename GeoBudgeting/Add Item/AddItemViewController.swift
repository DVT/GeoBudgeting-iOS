//
//  AddItemViewController.swift
//  GeoBudgeting
//
//  Created by David Minders on 5/6/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

protocol AddItemViewControllerProtocol: class {
    func updateView(model: FormModel)
}

class AddItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var categorySpinner: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var priceEditText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var toastView: UIView!
    @IBOutlet weak var viewOnMapButton: UIButton!
    
   
    
    var storeCategories = ["Finances", "Transport", "Entertainment", "Food", "Health", "Hobbies", "Services", "Shopping"]
    var selectedCategoryRow = 0
    var activeField: UITextField?
    var scrollviewInsets: UIEdgeInsets?
    var lat: Double?
    var lng: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up category picker
        categorySpinner.dataSource = self
        categorySpinner.delegate = self
        
        setupUI()
        
        registerForKeyboardNotifications()
        scrollviewInsets = self.scrollView.contentInset
        
        toastView.layer.cornerRadius = 8
        addItemButton.isEnabled = false
        
        storeNameTextField.delegate = self
        priceEditText.delegate = self
    }
    
    @IBAction func openCamera(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
       Functions.showLoadingIndicator(mustShow: true, viewController: self)
        
        guard let uiImage = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        ocr(cameraImage: uiImage) { model in
            var error = ""
            if let name = model.storeName {
                DispatchQueue.main.async {
                    self.storeNameTextField.text = name
                }
            } else {
                error += "Store details not found, please enter store name and choose category manually. \n"
            }
            var canEnableButton = true
            if let date = model.date {
                DispatchQueue.main.async {
                    self.datePicker.setDate(date, animated: true)
                }
            } else {
                canEnableButton = false
                error += "Date could not be found on receipt, please select manually. \n"
            }
            
            if let cat = model.category {
                let fetchedStorecategory = self.refineCategories(cats: cat)
                var count = 0
                for category in self.storeCategories {
                    if category == fetchedStorecategory {
                       self.selectedCategoryRow = count
                    }
                    count += 1
                }
                DispatchQueue.main.async {
                    self.categorySpinner.selectRow(self.selectedCategoryRow, inComponent: 0, animated: true)
                    self.categorySpinner.reloadAllComponents()
                }
            }
            
            if let total: Double = model.total {
                if total != -1 {
                    let  price = String(total)
                    DispatchQueue.main.async {
                        self.priceEditText.text = price
                    }
                } else {
                    canEnableButton = false
                    error += "Total could not be found on receipt, please enter manually"
                }
            }
            
            self.lat = model.lat
            self.lng = model.lng
            Functions.showLoadingIndicator(mustShow: false, viewController: self)
            if canEnableButton {
                DispatchQueue.main.async {
                self.addItemButton.isEnabled = true
                }
            }
            
            if error != "" {
                self.displayErrorPopup(error)
            }
        }
        
    }
    
    func refineCategories(cats: [String]) -> String {
        //storeCategories.removeAll()
        var refinedCategories: [String] = []
        for cat in cats {
            var c = ""
            switch cat {
            case "finances","accounting","atm","bank":
                c = "Finances"
            case "transport",
                 "airport","bus_station","car_dealer","car_rental","gas_station","parking", "subway_station", "taxi_stand",
                 "train_station",
                 "transit_station":
                c = "Transport"
            case "entertainment",
                 "amusement_park","aquarium","art_gallery","book_store","bowling_alley", "bar","campground", "casino","lodging",
                 "museum",
                 "night_club",
                 "rv_park",
                 "spa",
                 "stadium",
                 "travel_agency",
                 "movie_rental",
                 "movie_theater","zoo":
                c = "Entertainment"
            case "food",
                 "bakery", "cafe", "meal_delivery",
                 "restaurant":
                c = "Food"
            case "health",
                 "beauty_salon","dentist","hair_care","hospital",
                 "veterinary_care","pharmacy":
                c = "health"
            case "hobbies",
                 "bicycle_store","gym":
                c = "Hobbies"
            case "services","car_repair","car_wash","cemetery","church","courthouse","doctor","electrician","city_hall","embassy",
                 "fire_station","funeral_home","hindu_temple","insurance_agency","laundry","lawyer","library",
                 "local_government_office",
                 "locksmith",
                 "mosque",
                 "moving_company",
                 "painter",
                 "physiotherapist",
                 "plumber",
                 "police",
                 "post_office",
                 "real_estate_agency",
                 "roofing_contractor",
                 "park",
                 "school",
                 "storage",
                 "synagogue":
                c = "Services"
            case "shopping","clothing_store","convenience_store","department_store","electronics_store","florist","furniture_store","hardware_store","home_goods_store","insurance_agency","liquor_store",
                 "shoe_store",
                 "shopping_mall",
                 "store",
                 "supermarket",
                 "pet_store":
                c = "Shopping"
            default:
                c = ""
            }
            
            if !c.isEmpty {
                if !refinedCategories.contains(c) {
                    refinedCategories.append(c)
                }
            }
        }
        
        return refinedCategories[0]
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
        let storeName = storeNameTextField.text!
        let category = storeCategories[selectedCategoryRow]
        let stringAmount = priceEditText.text
        let amount = Double(stringAmount!) ?? 0
        
        let timestampString = getDateForStartOfDayAsString(fromDate: datePicker.date)
        
        if let lat = lat, let long = lng {
            FirebaseServices().addNewItem(storeName: storeName.lowercased(),
                                          storeCategory: category,
                                          dateTime: timestampString,
                                          amount: amount,
                                          latitude: lat,
                                          longitude: long )
        } else {
            CategoryListFinder().getCategories(storeName: storeName) { categories, lat, long in
                FirebaseServices().addNewItem(storeName: storeName.lowercased(),
                                              storeCategory: category,
                                              dateTime: timestampString,
                                              amount: amount,
                                              latitude: lat,
                                              longitude: long )
            }
        }
        
        refreshForm()
        showAddedItemMessage()

    }
    
   
    
    func displayErrorPopup(_ error: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    func refreshForm() {
        storeNameTextField.text = ""
        priceEditText.text = ""
        categorySpinner.selectRow(0, inComponent: 0, animated: true)
        datePicker.setDate(Date(), animated: true)
    }
    
    func showAddedItemMessage() {
        toastView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.toastView.isHidden = true
        }
    }
    
    @IBAction func viewOnMap(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0 //To go to map to see
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

extension AddItemViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        var isFilledName = false
        var isFilledPrice = false
        if (storeNameTextField.text?.isEmpty)! {
            isFilledName = false
        } else {
            isFilledName = true
        }
        
        if (priceEditText.text?.isEmpty)! {
            isFilledPrice = false
        } else {
            isFilledPrice = true
        }
        
        
        if isFilledPrice && isFilledName {
            addItemButton.isEnabled = true
        } else {
            addItemButton.isEnabled = false
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        storeNameTextField.resignFirstResponder()
        priceEditText.resignFirstResponder()
        dismissKeyboard()
        return true
    }
}
