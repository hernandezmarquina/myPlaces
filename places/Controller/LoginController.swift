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
    
    /// Indicate if the keyboard is visible on the screen
    private var isKeyboardVisible: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        registerNotificationObservers()
    }
    
    /**
         Calls this function when the tap is recognized.
     */
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func registerNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        print("keyboardWillShow")
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if !isKeyboardVisible {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                    isKeyboardVisible = true
                }
            }
        }
    }
    
    
    @objc func keyboardWillHide(_ notification: Notification) {
        print("keyboardWillHide")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
                isKeyboardVisible = false
            }
        }
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

