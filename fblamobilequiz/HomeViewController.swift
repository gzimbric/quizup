//
//  HomeViewController.swift
//  fblamobilequiz
//
//  Created by Gabe Zimbric on 3/4/19.
//  Copyright © 2019 Gabe Zimbric. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {

    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var latestScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationController?.navigationBar.topItem?.title = "Hi there, \(dictionary["username"]!)"
            }
        })
        
        Database.database().reference().child("users").child(uid!).child("maxScore").observeSingleEvent(of: .value) { (snapshot) in
            if let maxScore = snapshot.value as? Int {
                self.highScoreLabel.text = "\(maxScore)"
                //self.latestScoreLabel.text = dictionary["score"] as? Int
            }
        }
        
        Database.database().reference().child("users").child(uid!).child("score").observeSingleEvent(of: .value) { (snapshot) in
            if let score = snapshot.value as? Int {
                self.latestScoreLabel.text = "\(score)"
            }
        }
        
        self.quizButton.layer.cornerRadius = 5
        self.quizButton.alpha = 0.70
        
        self.logoutButton.layer.cornerRadius = 5
        self.logoutButton.alpha = 0.70

        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(vc!, animated: true, completion: nil)
        } catch {
            print("Error signing out user.")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
