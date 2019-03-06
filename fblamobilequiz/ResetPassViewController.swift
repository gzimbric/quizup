//
//  ResetPassViewController.swift
//  fblamobilequiz
//
//  Created by Gabe Zimbric on 3/4/19.
//  Copyright © 2019 Gabe Zimbric. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ResetPassViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Tap to dismiss Keyboard Gesture Recognizer
        
        // ViewController Styling
        self.emailTextField.alpha = 0.70
        self.resetButton.layer.cornerRadius = 5
        self.resetButton.alpha = 0.70
        
        self.hideKeyboardWhenTappedAround()
    }
    
    // Sends email to server for password reset
    @IBAction func submitAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success"
                    message = "A password reset link has been sent to your email."
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
}
