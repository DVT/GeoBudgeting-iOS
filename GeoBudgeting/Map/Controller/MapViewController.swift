//
//  ViewController.swift
//  GeoBudgeting
//
//  Created by Marie Kristein-Harmsen on 2019/05/03.
//  Copyright © 2019 DVT. All rights reserved.
//
import GooglePlaces
import GoogleMaps
import UIKit

class MapViewController: UIViewController, UITextFieldDelegate, GMSMapViewDelegate {
    //Firebase
    // let ref = Database.database().reference(withPath: "reciepts")
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
        self.showMarkers(lat: -26.201125007851232, long: 28.041075356304646)
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
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.map = self.mapView
        marker.icon = GMSMarker.markerImage(with: .black)
    }
}


