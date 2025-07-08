//
//  PullItUpApp.swift
//  PullItUp
//
//  Created by J on 7/7/25.
//

import SwiftUI
import SwiftData

@main
struct PullItUpApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [QuizItem.self, ImportedFile.self]) // SwiftData 사용을 위해 모델 등록
        }
    }
}
