//
//  ViewController.swift
//  places
//
//  Created by Jonathan Hernandez on 12/3/17.
//  Copyright © 2017 Jonathan Hdez. All rights reserved.
//

import UIKit

class LoginController: UIViewController, SignUpDelegate {

    @IBOutlet weak var emailTextFiel: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToSignUpView" {
            let destination = segue.destination as! SignUpController
            
            destination.delegate = self
        }
    }
    
    func signUpSuccessful(user: User) {
        emailTextFiel.text = user.email
        passwordTextField.text = user.password
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

