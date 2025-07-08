//
//  QuizSession.swift
//  PullItUp
//
//  Created by J on 7/8/25.
//

import Foundation
import SwiftData


enum QuizType: String, Codable {
    case short  // 10 문제 씩
    case long   // 모의고사
}

@Model
class QuizSession: Identifiable {
    var id: UUID = UUID()
    var licenseName: String         // 자격증 이름
    var quizType: QuizType          // 퀴즈 타입
    var startedAt: Date             // 시작 시간
    var endedAt: Date?              // 종료 시간

    @Relationship(deleteRule: .cascade)
    var answers: [QuizAnswer]  // 이 세션에서 푼 모든 문제 결과

    
    init(licenseName: String, quizType: QuizType, startedAt: Date = .now) {
        self.licenseName = licenseName
        self.quizType = quizType
        self.startedAt = startedAt
        self.answers = []
    }
}

extension QuizSession {
    // 과목 정답률 가져오기
    var subjectAccuracies: [SubjectAccuracy] {
        let grouped = Dictionary(grouping: self.answers, by: { $0.subject })

        return grouped.map { subject, answers in
            let correct = answers.filter { $0.isCorrect }.count
            
            return SubjectAccuracy(subject: subject, correctCount: correct, totalCount: answers.count)
        }
        .sorted { $0.subject < $1.subject } // 차트 순서 고정
    }
}
