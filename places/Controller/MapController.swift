//
//  MapController.swift
//  places
//
//  Created by Jonathan Hernandez on 12/4/17.
//  Copyright © 2017 Jonathan Hdez. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase
import CoreLocation


class MapController : UIViewController, CLLocationManagerDelegate, PlaceListDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    /// User id from **Firebase**.
    var user : String?
    
    /// Default **CLLocation** value to init the Map.
    let userLocation : CLLocation = CLLocation(latitude:37.758431, longitude: -122.445162)
    /// Default **CLLocationDistance** value to init the Map.
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        
        centerMapOnLocation(location: userLocation)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        user = Auth.auth().currentUser?.uid
        
        retrievePlaces()
    }
    
    /**
         Read data at a path **\(places/user\)** and listen for changes.
     */
    private func retrievePlaces() {
        let dbReferene = Database.database().reference().child("places").child(user!)
        
        dbReferene.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            
            let name = snapshotValue["name"] as! String
            let latitude = snapshotValue["latitude"] as! Double
            let longitude = snapshotValue["longitude"] as! Double
            
            let newPlace : Place = Place(placeName: name, lat: latitude, lng: longitude)
            
            self.addAnnotation(place: newPlace)
            
        }
    }
    
    /**
         Adds a specified annotation to the map view.
     */
    private func addAnnotation(place: Place) {
        let anotation = MKPointAnnotation()
        
        anotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        anotation.title = place.name
        
        self.mapView.addAnnotation(anotation)
    }
    

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("SignOut error")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
        
            let userLocation : CLLocation = CLLocation(latitude:location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            centerMapOnLocation(location: userLocation)
            
        }
    }
    
    
    @IBAction func addPlaceButtonPressed(_ sender: UIButton) {
        createPlace()
    }
    
    /**
         Start bulding a Place obj
     */
    private func createPlace() {
        
        let center = mapView.centerCoordinate
        
        let alert = UIAlertController(title: "New Place", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            
            let name : String = (alert?.textFields![0].text)!
            
            let place : [String : Any] = ["name": name, "latitude": center.latitude, "longitude": center.longitude]
            
            self.savePlace(place)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /**
     
         Save Place in Firebase
     
     - parameter place: Data in the correct format for save.
     
     */
    private func savePlace(_ place: [String: Any]){
        
        let placesDB = Database.database().reference().child("places").child(user!)
        
        placesDB.childByAutoId().setValue(place) { (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("Place saved successfully!")
                ProgressHUD.showSuccess("Saved")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    /**
     
         Change the current map center to a specific location
     
     - parameter location: location to center
     
     */
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToListView" {
            
            let destination = segue.destination as! PlaceListController
            
            destination.delegate = self
        }
    }
    
    func placeCellSelected(place: Place) {
        
        let location : CLLocation = CLLocation(latitude: place.latitude, longitude: place.longitude)
            
        centerMapOnLocation(location: location)
        openAnnotationDescription(place: place)
    }
    
    /**
     
         Display the annotation title on PlaceCell click
     
     - parameter place: Place selected
     
     */
    private func openAnnotationDescription(place: Place){
        for annotation in mapView.annotations as [MKAnnotation] {

            if annotation.title!! == place.name {
                mapView.selectAnnotation(annotation, animated: true)
                break
            }
        }
    }
}
