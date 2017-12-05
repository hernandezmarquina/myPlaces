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

class MapController : UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let userLocation : CLLocation = CLLocation(latitude:37.758431, longitude: -122.445162)
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
         centerMapOnLocation(location: userLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
