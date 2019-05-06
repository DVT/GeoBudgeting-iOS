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
    //Firebase
     let ref = Database.database().reference(withPath: "receipts")
    //Selecting location
    let search = SearchView()
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: GMSMapView!
    //layouts and delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        mapView.delegate = self
        search.searchTextView.delegate = self
        setUpTextView()
        //database
        ref.observe(.value, with: { snapshot in
            print(snapshot.value as Any)
        })
        ref.observe(.value, with: { snapshot in
            print("here1")
            for child in snapshot.children {
                print("here2")
                if let snapshot = child as? DataSnapshot,
                    let postItem = PostItem(snapshot: snapshot) {
                     print("here3")
                    print(postItem.storeName)
                    let locationMarker = self.reverseGeocodeCoordinateToCordinate(postItem.storeName)
                    let latMarker = locationMarker.latitude
                    let longMarker = locationMarker.longitude
                    print(latMarker)
                }
            }
        })
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
    func showMarkers(lat: Double, long: Double) {
        let marker=GMSMarker()
        marker.title = "Pick n Pay"
        marker.snippet = "Total Amount: R200"
        marker.map = self.mapView
        marker.icon = GMSMarker.markerImage(with: .black)
    }
}
extension MapViewController {
//    func reverseGeocodeCoordinateToString(_ coordinate: CLLocationCoordinate2D) -> String {
//        let geocoder = GMSGeocoder()
//        geocoder.reverseGeocodeCoordinate(coordinate) { response, _ in
//            guard let address = response?.firstResult(), let lines = address.lines else {
//                return
//            }
//            self.geoAddress = lines.joined(separator: "\n")
//        }
//        return geoAddress
//    }
    func reverseGeocodeCoordinateToCordinate(_ address: String) -> CLLocationCoordinate2D {
        let geoCoder = CLGeocoder()
        var addressCoordinates = CLLocation()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    return
            }
           addressCoordinates = location
        }
        print(addressCoordinates)
        return addressCoordinates.coordinate
}
}


