//
//  QuizItem.swift
//  PullItUp
//
//  Created by J on 7/8/25.
//

import Foundation
import SwiftData

@Model
final class QuizItem {
    var licenseName: String     // 자격증 이름
    var number: Int             // 문제 번호
    var question: String        // 질문
    var options: [String]       // 선택지 (1~4)
    var answer: String          // 답
    var explanation: String     // 해설
    var subject: String         // 과목 분류
    var imageName: String?      // 문제 본문에 들어갈 이미지 이름

    @Relationship var importedFile: ImportedFile?

    init(licenseName: String = "", number: Int, question: String, options: [String], answer: String, explanation: String, subject: String, imageName: String?) {
        self.licenseName = licenseName
        self.number = number
        self.question = question
        self.options = options
        self.answer = answer
        self.explanation = explanation
        self.subject = subject
        self.imageName = imageName ?? ""
    }
}
