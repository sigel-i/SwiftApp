//
//  Quiz.swift
//  Quiz
//
//  Created by 石井滋 on 2022/02/02.
//

import SwiftUI

struct Quiz: Decodable {
    let question: String
    let answer: String
    var choice: [String]
}
