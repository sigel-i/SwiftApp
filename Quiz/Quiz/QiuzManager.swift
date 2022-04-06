//
//  QiuzManager.swift
//  Quiz
//
//  Created by 石井滋 on 2022/02/01.
//

import SwiftUI

class QuizesManager: ObservableObject {
    var quiz = [Quiz]()
    @Published var presentQuiz = Quiz(question: "", answer: "",choice: ["","","",""])
    @Published var isFinished = false // クイズが終わったかどうか
    var number = 0 //問題番号.今何問目なのか示す
    var correct = 0 // 正解数
    
    func prepareQuestion() {
        presentQuiz = quiz[number]
        
        for i in 0 ..< presentQuiz.choice.count {
            let r = Int(arc4random_uniform(UInt32(presentQuiz.choice.count)))
            presentQuiz.choice.swapAt(i, r)
        }
    }
    
    func judge(answeredNumber: Int) {
        if presentQuiz.answer == presentQuiz.choice[answeredNumber]  {
            correct += 1
        }
        
        number += 1
        
        if number >= quiz.count {
            isFinished.toggle()
        } else {
            prepareQuestion()
        }
    }
}
