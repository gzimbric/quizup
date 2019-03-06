//
//  Question.swift
//  fblamobilequiz
//
//  Created by Gabe Zimbric on 12/6/18.
//  Copyright © 2018 Gabe Zimbric. All rights reserved.
//

import Foundation

class Question {
    let question : String
    let answer : Bool
    init (questionString : String, correctAnswer : Bool){
        question = questionString
        answer = correctAnswer
    }
}
