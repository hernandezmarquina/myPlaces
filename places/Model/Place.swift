//
//  Place.swift
//  places
//
//  Created by Jonathan Hernandez on 12/5/17.
//  Copyright © 2017 Jonathan Hdez. All rights reserved.
//

import Foundation

class Place {
    
    var name : String
    var latitude: Double
    var longitude: Double
    
    init(placeName: String, lat: Double, lng: Double) {
        
        name = placeName
        latitude = lat
        longitude = lng

    }
}
