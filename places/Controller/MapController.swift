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


class MapController : UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    let userLocation : CLLocation = CLLocation(latitude:37.758431, longitude: -122.445162)
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
         centerMapOnLocation(location: userLocation)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
