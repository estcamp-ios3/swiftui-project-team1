//
//  StatisticsModel.swift
//  PullItUp
//
//  Created by J on 7/8/25.
//

import Foundation


struct SubjectAccuracy: Identifiable {
    var id: String { subject }
    var subject: String         // 과목 분류
    var correctCount: Int       // 맞은 개수
    var totalCount: Int         // 전체 개수

    var accuracy: Double {
        totalCount == 0 ? 0 : Double(correctCount) / Double(totalCount)
    }
}
