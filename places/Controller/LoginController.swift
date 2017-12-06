//
//  ViewController.swift
//  places
//
//  Created by Jonathan Hernandez on 12/3/17.
//  Copyright © 2017 Jonathan Hdez. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController, SignUpDelegate {

    @IBOutlet weak var emailTextFiel: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        clearForm()
        
        if segue.identifier == "goToSignUpView" {
            let destination = segue.destination as! SignUpController
            
            destination.delegate = self
        }
    }
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        
        if (emailTextFiel.text?.isEmpty)! {
            
            ProgressHUD.showError("Email required")
            
        } else if (passwordTextField.text?.isEmpty)! {
            
            ProgressHUD.showError("Password required")
            
        }else{
            
            ProgressHUD.show()
            
            Auth.auth().signIn(withEmail: emailTextFiel.text!, password: passwordTextField.text!, completion: { (user, error) in
                
                
                if error != nil {
                    
                    ProgressHUD.showError(error?.localizedDescription)
                    
                }else{
                    
                    ProgressHUD.dismiss()
                    
                    self.performSegue(withIdentifier: "goToMapView", sender: self)
                    
                }
            })
        }
    }
    
    func signUpSuccessful(user: User) {
        emailTextFiel.text = user.email
        passwordTextField.text = user.password
    }
    
    func clearForm() {
        emailTextFiel.text = ""
        passwordTextField.text = ""
    }
    
}

