//
//  QuestionDB.swift
//  fblamobilequiz
//
//  Created by Gabe Zimbric on 12/6/18.
//  Copyright © 2018 Gabe Zimbric. All rights reserved.
//

import Foundation

class QuestionDB {
    var list = [Question]()
    
    init() {
        list.append(Question(questionString: "Is FBLA-PBL the largest career student business organization in the world? \n\nA: True, B: False", correctAnswer: true))
        
        list.append(Question(questionString: "How many states are chartered across the US in FBLA? \n\nA: 49 States, B: 47 States", correctAnswer: false))
        
        list.append(Question(questionString: "How many total FBLA chapters are there? \n\nA: 5,200, B: 4,700", correctAnswer: true))
        
        list.append(Question(questionString: "What is the name of the FBLA award that recognizes leadership in individuals? \n\nA: BAA awards, B: BWB Awards", correctAnswer: true))
        
        list.append(Question(questionString: "What year was FBLA established? \n\nA: 1950, B: 1940", correctAnswer: false))
        
        list.append(Question(questionString: "How many local chapters must a state have before becoming chartered? \n\nA: 5 chapters, B: 8 chapters", correctAnswer: true))
        
        list.append(Question(questionString: "How many national regions are there? \n\nA: 6 regions, B: 5 regions", correctAnswer: false))
        
        list.append(Question(questionString: "Which national region would Virginia be located in? \n\nA: Easten Region, B: Southern Region", correctAnswer: false))
        
        list.append(Question(questionString: "Who is the 2018-2019 FBLA National FBLA president? \n\nA: Eu Ro Wang, B: Brenen Skalitzky", correctAnswer: true))
        
        list.append(Question(questionString: "Where is the FBLA Headquarters located? \n\nA: Reston, Vigrinia \nB: Milwuakee, Wisconsin", correctAnswer: true))
        
        list.append(Question(questionString: "What is the main FBLA publication? \n\nA: Buisness attire of the future \nB: Tomorrow’s Business Leader", correctAnswer: false))
        
        list.append(Question(questionString: "How many total competitive FBLA events are there in 2019? \n\nA: 72, B: 85", correctAnswer: true))
        
        list.append(Question(questionString: "In what state was the first FBLA HS chapter chartered in 1942? \n\nA: Tennessee, B: California", correctAnswer: true))
        
        list.append(Question(questionString: "In what year was the FBLA-PBL National Center opened? \n\nA: 1996, B: 1991", correctAnswer: false))
        
        list.append(Question(questionString: "How many hours of service are required to earn the CSA Achievement award? \n\nA: 500, B: 650", correctAnswer: true))
    }
}
