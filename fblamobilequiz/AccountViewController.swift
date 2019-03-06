//
//  AccountViewController.swift
//  fblamobilequiz
//
//  Created by Gabe Zimbric on 3/4/19.
//  Copyright © 2019 Gabe Zimbric. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AccountViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var maxScoreCreator : Int = 0
    var scoreCreator : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ViewController Styling
        self.emailTextField.alpha = 0.70
        self.passwordTextField.alpha = 0.70
        self.usernameTextField.alpha = 0.70
        self.registerButton.layer.cornerRadius = 5
        self.registerButton.alpha = 0.70
        
        self.hideKeyboardWhenTappedAround()
    }

    
    // Create new user account
    @IBAction func createAccountAction(_ sender: AnyObject) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        let email = emailTextField.text
        
        // Shows error if any field is empty
        if emailTextField.text == "" || self.usernameTextField.text == "" || self.passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter info into all fields", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
                
                if error == nil {
                    
                    // Console message for successful registration
                    print("Sign up successful.")
                    
                    // Create user in database
                    if let uid = Auth.auth().currentUser?.uid {
                        let userRef = Database.database().reference().child("users").child(uid)
                        let object = [
                            "username": username!,
                            "score" : self.scoreCreator,
                            "maxScore" : self.maxScoreCreator
                            ] as [String : Any]
                        userRef.setValue(object)
                        
                        // Show feed if registration is successful
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                        self.present(vc!, animated: true, completion: nil)
                    }
                    
                        
                    // If error occurs, show UIAlertController from Firebase
                else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
