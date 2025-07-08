//
//  Test.swift
//  PullItUp
//
//  Created by J on 7/8/25.
//

import SwiftUI
import SwiftData

struct TestView: View {
    @Query(sort: [SortDescriptor(\QuizItem.number, order: .forward)]) var items: [QuizItem]     // 오름차순으로 정렬한 QuizItem을 @Query를 통해 가져옴

    var body: some View {
        NavigationStack {
            List(items.prefix(5)) { item in // 예시로 5개만 출력
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
            .navigationTitle("테스트 문제")
        }
    }
}
