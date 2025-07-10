//
//  Test.swift
//  PullItUp
//
//  Created by J on 7/8/25.
//

import SwiftUI
import SwiftData

struct TestView: View {
    @Query(sort: [SortDescriptor(\ImportedFile.fileName, order: .forward)])
    var importedFiles: [ImportedFile]  // 🔥 파일 목록

    var body: some View {
        NavigationStack {
            List {
                ForEach(importedFiles) { file in
                    Section(header: Text(file.fileName).font(.headline)) {
                        ForEach(file.quizItems.sorted(by: { $0.number < $1.number }).prefix(3)) { item in  // 🔥 각 파일당 3문제만
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Q\(item.number). \(item.question)")
                                    .font(.headline)

                                ForEach(item.options.indices, id: \.self) { idx in
                                    Text("\(idx + 1). \(item.options[idx])")
                                }

                                Text("정답: \(item.answer)")
                                    .foregroundColor(.blue)

                                Text("설명: \(item.explanation)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("파일별 테스트 문제")
        }
    }
}
