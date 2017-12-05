//
//  User.swift
//  places
//
//  Created by Jonathan Hernandez on 12/5/17.
//  Copyright © 2017 Jonathan Hdez. All rights reserved.
//

import Foundation

class User {
    
    var email : String
    var password : String
    
    init(_ userEmail : String,_ userPassword: String) {
        email = userEmail
        password = userPassword
    }
}
