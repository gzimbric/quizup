//
//  ViewController.swift
//  fblamobilequiz
//
//  Created by Gabe Zimbric on 12/6/18.
//  Copyright © 2018 Gabe Zimbric. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    let allQuestions = QuestionDB()
    var chosenAnswer : Bool = false
    var correctAnswer : Bool = false
    var questionNumber : Int = 1
    var score : Int = 0
    var maxScore : Int = 0
    let gameID = UUID().uuidString
    var posts = NSMutableArray()
    var currentUser = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let firstQuestion = allQuestions.list[0]
        questionLabel.text = firstQuestion.question
        correctAnswer = firstQuestion.answer
        refreshUI()
        
        self.navigationController?.navigationItem.backBarButtonItem?.title = "Back"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.buttonA.layer.cornerRadius = 5
        self.buttonA.alpha = 0.70
        self.buttonB.layer.cornerRadius = 5
        self.buttonB.alpha = 0.70
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Question \(questionNumber)/15"
    }
    
    @IBAction func answerPressed(_ sender: AnyObject) {
        if sender.tag == 1 {
            chosenAnswer = true
        } else {
            chosenAnswer = false
        }
        checkAnswer()
        questionNumber+=1
        self.navigationController?.navigationBar.topItem?.title = "Question \(questionNumber)/15"
        if questionNumber < 15 {
            questionLabel.text = allQuestions.list[questionNumber].question
            correctAnswer = allQuestions.list[questionNumber].answer
            refreshUI()
        } else {
            let alert = UIAlertController(title: "Quiz finished"
                , message: "Save to cloud? Final score: \(score)"
                , preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                self.startOver()
                self.updateScore()
            }
            let alertAction2 = UIAlertAction(title: "No", style: .default) { (UIAlertAction) in
                self.erase()
                self.refreshUI()
            }
            alert.addAction(alertAction)
            alert.addAction(alertAction2)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func refreshUI() {
        scoreLabel.text = "Score : \(score)"
    }
    
    func checkAnswer() {
        if chosenAnswer == correctAnswer {
            scoreLabel.textColor = UIColor.green
            score += 5
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                UIView.transition(with: self.scoreLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.scoreLabel.textColor = .black
                }, completion: nil)
            }
        } else {
            scoreLabel.textColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                UIView.transition(with: self.scoreLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.scoreLabel.textColor = .black
                }, completion: nil)
            }
        }
    }
    
    
    func startOver() {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let userDictionary = snapshot.value as? [String: AnyObject] {
                    for user in userDictionary {
                        if let username = user.value as? String {
                                let postObject: Dictionary<String, Any> = [
                                    "uid": uid,
                                    "score": self.score,
                                    "username" : username,
                                    "postID": self.gameID,
                                    ]
                            Database.database().reference().child("userposts").child(uid).child(self.gameID).setValue(postObject)
                            
                            let alert = UIAlertController(title: "Success", message: "Quiz results successfully uploaded to the cloud", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                                                self.present(vc!, animated: true, completion: nil)
                                            }))
                                            self.present(alert, animated: true, completion: {
                                            })
                                            
                                            print("Successfully Posted to DB.")
                                        }
                                    }
                                }
                    }
            )} else if currentUser == nil {
            let alert = UIAlertController(title: "Error", message: "Unable to upload to the cloud. Currently in guest mode.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.erase()
        } else {
            let alert = UIAlertController(title: "Error", message: "Unable to upload to the cloud. Are you offline?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateScore() {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let userDictionary = snapshot.value as? [String: AnyObject] {
                    self.maxScore = userDictionary["maxScore"] as! Int
                    print(self.maxScore)
                    if self.score > self.maxScore {
                        for user in userDictionary {
                            if let username = user.value as? String {
                                let postObject: Dictionary<String, Any> = [
                                    "score": self.score,
                                    "username" : username,
                                    "maxScore" : self.score
                                    ]
                                            Database.database().reference().child("users").child(uid).setValue(postObject)
                            }
                        }
                    } else {
                        for user in userDictionary {
                            if let username = user.value as? String {
                                let postObject: Dictionary<String, Any> = [
                                    "score" : self.score,
                                    "username" : username,
                                    "maxScore" : self.maxScore
                                ]
                                Database.database().reference().child("users").child(uid).setValue(postObject)
                            }
                        }
                    }
                }
            })
        }
    }
    
    func erase() {
        score = 0
        questionNumber = 0
        questionLabel.text = allQuestions.list[0].question
        correctAnswer = allQuestions.list[0].answer
        refreshUI()
        let alert = UIAlertController(title: "Results not saved", message: "Quiz has been reset and results were not uploaded to the cloud", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

