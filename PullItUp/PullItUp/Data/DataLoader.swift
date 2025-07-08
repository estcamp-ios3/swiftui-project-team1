//
//  DataLoader.swift
//  PullItUp
//
//  Created by J on 7/8/25.
//

import Foundation
import SwiftData


class DataLoader {
    static func loadJSONAndSave(modelContext: ModelContext) {
        let jsonPaths = Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil)

        for path in jsonPaths {
            let url = URL(fileURLWithPath: path)
            let fileName = url.lastPathComponent

            let isAlreadySaved = (try? modelContext.fetch(
                FetchDescriptor<ImportedFile>(predicate: #Predicate { $0.fileName == fileName })
            ))?.isEmpty == false

            guard !isAlreadySaved else {
                print("⏭️ \(fileName) 은 이미 처리됨")
                
                continue
            }

            guard let data = try? Data(contentsOf: url),
                  let decoded = try? JSONDecoder().decode([QuizItemDTO].self, from: data) else {
                print("❌ \(fileName) 디코딩 실패")
                
                continue
            }

            // 🔥 파일 로그 객체 먼저 생성
            let importedFile = ImportedFile(fileName: fileName)
            modelContext.insert(importedFile)

            // 🔥 문제 저장 + 연결
            for item in decoded {
                let quiz = QuizItem(
                    licenseName: item.licenseName,
                    number: item.number,
                    question: item.question,
                    options: item.options,
                    answer: item.answer,
                    explanation: item.explanation,
                    subject: item.subject,
                    imageName: item.imageName
                )

                quiz.importedFile = importedFile
                modelContext.insert(quiz)
            }

            print("✅ \(fileName) → \(decoded.count)개 저장 완료")
        }
    }
}
