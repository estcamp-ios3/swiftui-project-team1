//
//  ImportedFile.swift
//  PullItUp
//
//  Created by J on 7/8/25.
//

import Foundation
import SwiftData

@Model
class ImportedFile: Identifiable {
    var id: UUID = UUID()
    var fileName: String    // JSON 파일 이름

    @Relationship(deleteRule: .cascade)
    var quizItems: [QuizItem] = []

    init(fileName: String) {
        self.fileName = fileName
    }
}
