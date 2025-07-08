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
        // 번들에서 모든 JSON 파일 경로 가져오기
        let jsonPaths = Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil)

        for path in jsonPaths {
            let url = URL(fileURLWithPath: path)
            let fileName = url.lastPathComponent

            // 이미 저장된 파일이면 넘어간다
            let isAlreadySaved = (try? modelContext.fetch(
                FetchDescriptor<ImportedFile>(predicate: #Predicate { $0.fileName == fileName })
            ))?.isEmpty == false

            guard !isAlreadySaved else {
                print("⏭️ \(fileName) 은 이미 처리됨")
                
                continue
            }

            // JSON 파일 디코딩
            guard let data = try? Data(contentsOf: url),
                  let decoded = try? JSONDecoder().decode([QuizItemDTO].self, from: data) else {
                print("❌ \(fileName) 디코딩 실패")
                
                continue
            }

            // SwiftData에 저장
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
                
                modelContext.insert(quiz)
            }

            // 처리한 파일 기록 추가 (이미 처리한 파일을 또 처리하지 않기 위함)
            let fileLog = ImportedFile(fileName: fileName)
            modelContext.insert(fileLog)

            print("✅ \(fileName) → \(decoded.count)개 저장 완료")
        }
    }
}
