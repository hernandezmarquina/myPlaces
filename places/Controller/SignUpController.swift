//
//  SignUpController.swift
//  places
//
//  Created by Jonathan Hernandez on 12/5/17.
//  Copyright © 2017 Jonathan Hdez. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

protocol SignUpDelegate {
    func signUpSuccessful(user: User)
}

class SignUpController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var delegate : SignUpDelegate?
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        if (emailTextField.text?.isEmpty)! {
            ProgressHUD.showError("email Required")
        } else {
            if !isThePasswordValid() {
                
                ProgressHUD.showError("Passwords do not match")
                
            } else {
                
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                    
                    if error != nil {
                        
                        ProgressHUD.showError(error?.localizedDescription)
                        
                    } else {
                        
                        ProgressHUD.showSuccess()
                        
                        self.delegate?.signUpSuccessful(user: User(self.emailTextField.text!, self.passwordTextField.text!))
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                })
            }
        }
        
    }
    
    func isThePasswordValid() -> Bool {
        
        var result : Bool = false
        
        if (passwordTextField.text?.isEmpty)! {
            return result
        }
        
        if passwordTextField.text == confirmPasswordTextField.text {
                // Success
                result = true
        } else {
                // Wrong passwords
                passwordTextField.text = ""
                confirmPasswordTextField.text = ""
                passwordTextField.becomeFirstResponder()
        }
        return result
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
