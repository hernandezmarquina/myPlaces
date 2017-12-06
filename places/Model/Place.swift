//
//  Place.swift
//  places
//
//  Created by Jonathan Hernandez on 12/5/17.
//  Copyright © 2017 Jonathan Hdez. All rights reserved.
//

import Foundation

class Place {
    
    var name : [String : String]
    var latitude: [String: Double]
    var longitude: [String : Double]
    
    init(placeName: String, lat: Double, lng: Double) {
        
        name = ["name": placeName]
        latitude = ["latitude": lat]
        longitude = ["longitude": lng]
        
    }
}
