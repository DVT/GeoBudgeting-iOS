//
//  ViewController.swift
//  GeoBudgeting
//
//  Created by Marie Kristein-Harmsen on 2019/05/03.
//  Copyright © 2019 DVT. All rights reserved.
//
import GooglePlaces
import GoogleMaps
import Firebase
import UIKit

class MapViewController: UIViewController, UITextFieldDelegate, GMSMapViewDelegate {
    
    
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var entertainmentButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var hobbiesButton: UIButton!
    @IBOutlet weak var transportButton: UIButton!
    @IBOutlet weak var servicesButton: UIButton!
    @IBOutlet weak var healthButton: UIButton!
    @IBOutlet weak var financesButton: UIButton!
    @IBOutlet weak var unknownButton: UIButton!
    
    
    
    
    
    
    
    @IBOutlet weak var hoverLabel: UILabel!
    
    var buttonGroup: [UIButton] = []
    
    
    //Firebase
    let ref = Database.database().reference(withPath: "receipts/\(userID)")
    //Selecting location
    let search = SearchView()
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: GMSMapView!
    //layouts and delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonGroup = [foodButton, entertainmentButton, shoppingButton, hobbiesButton, transportButton, healthButton, servicesButton, financesButton, unknownButton]
        setUpLocationManager()
        mapView.delegate = self
        search.searchTextView.delegate = self
        setUpTextView()
        //database
//        ref.observe(.value, with: { snapshot in
//            print(snapshot.value as Any)
//        })
                
        if userID != "" {
            ref.observe(.value, with: { snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let postItem = PostItem(snapshot: snapshot) {
                        let latMarker = postItem.mapLatitude
                        let longMarker = postItem.mapLongitude
                        let titleMarker = postItem.key
                        let selectedCategory = postItem.category
                        let category = self.getCategory(category: selectedCategory)
                        var amountMarker = 0.00
                        Database.database().reference().child("receipts").child(userID).child(postItem.key).child("date").observeSingleEvent(of: .value) { datasnapshot in
                            if datasnapshot.exists() {
                                for snap in datasnapshot.children.allObjects {
                                    if let snap = snap as? DataSnapshot {
                                        let timestamp = snap.key
                                        let purchaseDate = self.getDateFromStamp(serverTimestamp: timestamp)
                                        let currentDate = Date()
                                        let difference = currentDate.interval(ofComponent: .day, fromDate: purchaseDate)
                                        
                                        let selectedHistoryOptionIndex = UserDefaults.standard.integer(forKey: "history")
                                        var period = 0
                                        
                                        switch selectedHistoryOptionIndex {
                                        case 0: period = 30
                                        case 1: period = 60
                                        case 2: period = 90
                                        default:
                                            period = 0
                                        }
                                        
                                        if difference <= period {
                                            let moneySpent = snap.value
                                            amountMarker += moneySpent as! Double
                                        }
                                        
                                    }
                                }
                            }
                            if amountMarker > 0 {
                                 self.showMarkers(title: titleMarker, amount: amountMarker, lat: latMarker, long: longMarker, categoryMarker : category)
                            }
                        }
                    }
                }
            })
        }
    }
    
    func getDateFromStamp(serverTimestamp: String) -> Date {
        let time = Int(serverTimestamp) ?? 0 / 1000
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        return date
    }
    
    //location manager
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    //search
    func setUpTextView() {
        self.view.addSubview(search.searchTextView)
        search.searchTextView.topAnchor.constraint(equalTo:
            view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        search.searchTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        search.searchTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        search.searchTextView.heightAnchor.constraint(equalToConstant: 35).isActive=true
    }
    
    @IBAction func openModal(_ sender: Any) {
        let alert = UIAlertController(title: title, message: "Pick a category", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSelect(selectedIndex: Int) {
        for i in 0..<buttonGroup.count {
            let button = buttonGroup[i]
            if i == selectedIndex {
                if button.backgroundColor == UIColor.cyan {
                    button.backgroundColor = .clear
                    //remove filter from map
                } else {
                    button.backgroundColor = .lightGray
                    //add fitler to map
                }
            } else {
                button.backgroundColor = .clear
            }
        }
    }
    
    @IBAction func applyFoodFilter(_ sender: Any) {
        showSelect(selectedIndex: 0)
        hoverLabel.center.y = foodButton.center.y
        hoverLabel.text = "Food"
        hoverLabel.isHidden = false
        hoverLabel.sizeToFit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hoverLabel.isHidden = true
        }
    }
    
    @IBAction func applyEntertainmentFilter(_ sender: Any) {
        showSelect(selectedIndex: 1)
        hoverLabel.center.y = entertainmentButton.center.y
        hoverLabel.text = "Entertainment"
        hoverLabel.isHidden = false
        hoverLabel.sizeToFit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hoverLabel.isHidden = true
        }
    }
    
    @IBAction func applyShoppingFilter(_ sender: Any) {
        showSelect(selectedIndex: 2)
        hoverLabel.center.y = shoppingButton.center.y
        hoverLabel.text = "Shopping"
        hoverLabel.isHidden = false
        hoverLabel.sizeToFit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hoverLabel.isHidden = true
        }
    }
    
    @IBAction func applyHobbiesFilter(_ sender: Any) {
        showSelect(selectedIndex: 3)
        hoverLabel.center.y = hobbiesButton.center.y
        hoverLabel.text = "Hobbies"
        hoverLabel.isHidden = false
        hoverLabel.sizeToFit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hoverLabel.isHidden = true
        }
    }
    
    @IBAction func applyTransportButton(_ sender: Any) {
        showSelect(selectedIndex: 4)
        hoverLabel.center.y = transportButton.center.y
        hoverLabel.text = "Transport"
        hoverLabel.isHidden = false
        hoverLabel.sizeToFit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hoverLabel.isHidden = true
        }
    }
    
    @IBAction func applyHealthFilter(_ sender: Any) {
        showSelect(selectedIndex: 5)
        hoverLabel.center.y = healthButton.center.y
        hoverLabel.text = "Health"
        hoverLabel.isHidden = false
        hoverLabel.sizeToFit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hoverLabel.isHidden = true
        }
    }
    
    @IBAction func applyServicesFilter(_ sender: Any) {
        showSelect(selectedIndex: 6)
        hoverLabel.center.y = servicesButton.center.y
        hoverLabel.text = "Services"
        hoverLabel.isHidden = false
        hoverLabel.sizeToFit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hoverLabel.isHidden = true
        }
    }
    
    @IBAction func applyFinancesFilter(_ sender: Any) {
        showSelect(selectedIndex: 7)
        hoverLabel.center.y = financesButton.center.y
        hoverLabel.text = "Finances"
        hoverLabel.isHidden = false
        hoverLabel.sizeToFit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hoverLabel.isHidden = true
        }
    }
    
    @IBAction func applyUnknownFilter(_ sender: Any) {
        showSelect(selectedIndex: 8)
        hoverLabel.center.y = unknownButton.center.y
        hoverLabel.text = "Unknown"
        hoverLabel.isHidden = false
        hoverLabel.sizeToFit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hoverLabel.isHidden = true
        }
    }
}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus ) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        guard let location = locations.last else {
            return
        }
        locationManager.stopUpdatingLocation()
        let lat = (location.coordinate.latitude)
        let long = (location.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
        self.mapView.animate(to: camera)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("An unexpected Error occured while getting the location")
    }
    
}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}

//Search places
extension MapViewController: GMSAutocompleteViewControllerDelegate {
    func textFieldShouldBeginEditing(_ searchTextView: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        mapView.camera = camera
        search.searchTextView.text=place.formattedAddress
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "\(String(describing: place.name))"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = mapView
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController,
                        didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension MapViewController {
    func showMarkers(title: String, amount: Double, lat: Double, long: Double, categoryMarker: UIColor) {
        var colorCategory : String!
        var infoCategory = ""
        let marker=GMSMarker()
        ref.observe(.value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let postItem = PostItem(snapshot: snapshot) {
                    let user = Auth.auth().currentUser
                    if user != nil {
                    let infoTitle = title
                    let totalMoneySpent = String(format: "%g", amount)
                    let infoSnippet = totalMoneySpent
                    infoCategory = postItem.category
                    marker.title = infoTitle
                    marker.snippet = "R" + String(infoSnippet)
                    marker.icon = GMSMarker.markerImage(with: categoryMarker)
                    marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    marker.map = self.mapView
                }
                }
            }
            })
    }
    func getCategory(category: String) -> UIColor {
    let finances = [
        "Finances","finances","accounting","atm","bank"]
    let transport =
    ["Transport", "transport",
        "airport","bus_station","car_dealer","car_rental","gas_station","parking",
    "subway_station",
    "taxi_stand",
    "train_station",
    "transit_station"]
    let entertainment =
    ["Entertainment", "entertainment",
        "amusement_park","aquarium","art_gallery","book_store","bowling_alley", "bar","campground", "casino","lodging",
    "museum",
    "night_club",
    "rv_park",
    "spa",
    "stadium",
    "travel_agency",
    "movie_rental",
    "movie_theater","zoo"]
    let food =
    ["Food", "food" ,
        "bakery", "cafe", "meal_delivery",
    "restaurant"]
    let health =
    ["Health", "health",
        "beauty_salon","dentist","hair_care","hospital",
    "veterinary_care","pharmacy"]
    let hobbies =
    ["Hobbies", "hobbies",
        "bicycle_store","gym"]
        let services =  ["Services","services","car_repair","car_wash","cemetery","church","courthouse","doctor","electrician","city_hall","embassy",
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
    "synagogue"]
    let shopping = ["Shopping","shopping","clothing_store","convenience_store","department_store","electronics_store","florist","furniture_store","hardware_store","home_goods_store","insurance_agency","liquor_store",
    "shoe_store",
    "shopping_mall",
    "store",
    "supermarket",
    "pet_store"]
        var currentIndex = 0
        for items in finances
        {
            if items == category {
                let color = UIColor.black
                return color
            }
            
            currentIndex += 1
        }
        currentIndex = 0
        for items in transport
        {
            if items == category {
                let color = UIColor.orange
                return color
            }
            
            currentIndex += 1
        }
       currentIndex = 0
        for items in entertainment
        {
            if items == category {
                let color = UIColor.purple
                return color
            }

            currentIndex += 1
        }
        currentIndex = 0
        for items in food
        {
            if items == category {
                let color = UIColor.brown
                return color
            }

            currentIndex += 1
        }
        currentIndex = 0
        for items in health
        {
            if items == category {
                let color = UIColor.green
                return color
            }
            
            currentIndex += 1
        }
        for items in hobbies
        {
            if items == category {
                let color = UIColor.white
                return color
            }
            
            currentIndex += 1
        }
        for items in services
        {
            if items == category {
                let color = UIColor.yellow
                return color
            }
            
            currentIndex += 1
        }
        for items in shopping
        {
            if items == category {
                let color = UIColor.blue
                return color
            }
            
            currentIndex += 1
        }
        return UIColor.gray
    }
}


