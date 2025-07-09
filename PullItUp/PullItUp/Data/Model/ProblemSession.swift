//
//  ProblemSession.swift
//  PullItUp
//
//  Created by suji chae on 7/8/25.
//

import Foundation
import SwiftData

@Model
final class ProblemSession: Identifiable {
    var id: UUID
    var date: Date
    var sessionNumber: Int
    // SwiftData가 직접 저장할 String 타입의 속성
    var quizTypeRawValue: String
    var scoreNumerator: Int
    var scoreDenominator: Int
    var isCompleted: Bool

    // 모든 저장 프로퍼티를 초기화하는 Designated Initializer (명시적 초기화)
    init(id: UUID = UUID(), // id에 기본값을 부여하고 init에서 명시적으로 초기화합니다.
         date: Date,
         sessionNumber: Int,
         quizType: QuizType, // 초기화 시에는 QuizType을 받음
         scoreNumerator: Int,
         scoreDenominator: Int,
         isCompleted: Bool = false) { // isCompleted는 기본값 유지
        
        self.id = id // id를 명시적으로 초기화
        self.date = date
        self.sessionNumber = sessionNumber
        // QuizType의 rawValue (문자열)를 quizTypeRawValue에 저장
        self.quizTypeRawValue = quizType.rawValue // <-- 여기서 QuizType의 rawValue를 사용합니다.
        self.scoreNumerator = scoreNumerator
        self.scoreDenominator = scoreDenominator
        self.isCompleted = isCompleted
    }

    // SwiftData 모델에서 직접 사용되는 속성. quizTypeRawValue를 QuizType으로 변환하여 반환
    var quizType: QuizType { // <-- 이 부분은 저장되지 않고 계산되는 '연산 프로퍼티'입니다.
        get {
            // rawValue를 이용해 QuizType을 생성. 만약 실패하면 .short로 기본값 설정 (에러 방지)
            // 모든 QuizType 케이스가 처리되므로 실제로는 nil이 될 일은 거의 없습니다.
            return QuizType(rawValue: quizTypeRawValue) ?? .short
        }
        set {
            // quizType이 설정될 때 quizTypeRawValue도 업데이트
            quizTypeRawValue = newValue.rawValue
        }
    }
}
