//
//  PlaceListController.swift
//  places
//
//  Created by Jonathan Hernandez on 12/7/17.
//  Copyright © 2017 Jonathan Hdez. All rights reserved.
//

import Foundation
import Firebase

protocol PlaceListDelegate {
    func placeCellSelected(place: Place)
}

class PlaceListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /// Object list to display in the TableView
    var places: [Place] = [Place]()
    
    /// User id from **Firebase**
    var user: String?
    
    /// The object that acts as the delegate of the PlaceList
    var delegate : PlaceListDelegate?
    
    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var placesCountLabel: UILabel!
    
    override func viewDidLoad() {
        
        // Get user id
        user = Auth.auth().currentUser?.uid
        
        // Register **.xib** file in TableView
        placesTableView.register(UINib(nibName: "PlaceCell", bundle: nil), forCellReuseIdentifier: "placeCell")
        
        // Remove separator line from TableView
        placesTableView.separatorStyle = .none
        
        // Assign delegate and dataSource
        placesTableView.delegate = self
        placesTableView.dataSource = self
        
        // Create the Firebase reference
        let dbReference = Database.database().reference().child("places").child(user!)
        
        // Get data from the db reference only once.
        dbReference.observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.value == nil {
                
                ProgressHUD.showError("Error downloading Places")
                
            }else {
                
                self.placesCountLabel.text = String(snapshot.childrenCount)
                
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let place = item.value as! [String: Any]
                    
                    let name = place["name"] as! String
                    let latitude = place["latitude"] as! Double
                    let longitude = place["longitude"] as! Double
                    
                    self.addPlace(place: Place(placeName: name, lat: latitude, lng: longitude))
                    
                }
                
                self.placesTableView.reloadData()
            }
        }
    }
    
    /**
     
     Append place to the list
     - parameter place: Place Obj to append

     */
    func addPlace(place: Place){
        places.append(place)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceCell
        
        cell.placeName.text = places[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Row selected: ", indexPath.row)
        
        let placeSelected : Place = places[indexPath.row]
        
        delegate?.placeCellSelected(place: placeSelected)
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else{
                print("No View Controllers to pop off")
                return
        }
    }
    
    
}
