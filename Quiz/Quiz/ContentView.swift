//
//  ContentView.swift
//  Quiz
//
//  Created by 石井滋 on 2022/01/31.
//

import SwiftUI

struct QuizView: View {
    @ObservedObject var quiz = QuizesManager()
        
    var body: some View {
        VStack {
            Text("No.\(quiz.number + 1)/\(quiz.quiz.count)")
                .foregroundColor(Color.gray)
            Spacer()
            Text(quiz.presentQuiz.question).font(.title)
            Spacer()
            ForEach( 0..<4) { i in
                Button(action: {
                    quiz.judge(answeredNumber: i)
                }){
                    HStack {
                        Text("   \(i + 1).")
                            .foregroundColor(Color.gray)
                            .frame(width: 50, height: 50)
                        Text(quiz.presentQuiz.choice[i])
                            .frame(width: UIScreen.main.bounds.width - 60, height: 50, alignment: .leading)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 10, height: 50)
                .disabled(quiz.isFinished)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.blue))
                .padding(2)
            }
            Spacer()
        }.onAppear(perform: {
            loadQuiz()
            quiz.prepareQuestion()
        })
        .sheet(isPresented: $quiz.isFinished) {
            ResultView(numberOfQuestion: quiz.number, correct: quiz.correct)
        }
    }
    
    func loadQuiz() {
        quiz.quiz = load("quizData.json")
    }
}

struct ResultView: View {
    var numberOfQuestion: Int
    var correct: Int
    
    var body: some View {
        Text("問題数: \(numberOfQuestion)")
        Text("正解数: \(correct)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
