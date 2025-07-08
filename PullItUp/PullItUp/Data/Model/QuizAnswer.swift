//
//  QuizAnswer.swift
//  PullItUp
//
//  Created by J on 7/8/25.
//

import Foundation
import SwiftData


@Model
class QuizAnswer {
    var id: UUID = UUID()
    var questionNumber: Int         // 문제 번호
    var quizItemID: UUID            // QuizItem과 매핑하려면 필요
    var subject: String             // 과목 분류
    var selectedAnswer: String      // 선택한 답변 정보
    var isCorrect: Bool             // 정답 유무

    @Relationship
    var session: QuizSession        // 어느 세션에 속한 답안인지 체크하기 위한 변수

    init(questionNumber: Int, quizItemID: UUID, subject: String, selectedAnswer: String, isCorrect: Bool, session: QuizSession) {
        self.questionNumber = questionNumber
        self.quizItemID = quizItemID
        self.subject = subject
        self.selectedAnswer = selectedAnswer
        self.isCorrect = isCorrect
        self.session = session
    }
}
