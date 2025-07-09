//
//  HistorySection.swift
//  PullItUp
//
//  Created by catharina J on 7/7/25.
//
import SwiftUI
import SwiftData

struct HistorySection: View {
    @Query(sort: [
        // 1. ProblemSession.date는 Date 타입이므로 그대로 사용합니다.
        SortDescriptor(\ProblemSession.date, order: .reverse),
        
        // 2. QuizType의 rawValue (String)에 대한 KeyPath를 직접 지정하여 정렬합니다.
        //    String은 기본적으로 Comparable을 준수하므로 별도의 클로저가 필요 없습니다.
        //    "short"와 "long"의 알파벳 순서대로 정렬됩니다.
        SortDescriptor(\ProblemSession.quizTypeRawValue, order: .forward)
    ], animation: .default)
    private var recentSessions: [ProblemSession]

    var body: some View {
        Section("최근 풀이 이력") {
            if recentSessions.isEmpty {
                ContentUnavailableView("아직 풀이 이력이 없어요.", systemImage: "chart.bar.doc.horizontal")
            } else {
                ForEach(recentSessions) { session in
                    NavigationLink(destination: Text("세션 상세 뷰: \(session.sessionNumber)")) {
                        HStack {
                            Text("세션 \(session.sessionNumber)")
                            Spacer()
                            // 예시로 퀴즈 타입을 표시합니다.
                            Text("\(session.quizType.rawValue.capitalized)")
                            Text("\(session.scoreNumerator) / \(session.scoreDenominator)")
                        }
                    }
                }
            }
        }
    }
}

// Preview를 위한 코드 (선택 사항)
#Preview {
    HistorySection()
        .modelContainer(for: ProblemSession.self, inMemory: true) // 미리보기를 위해 임시 컨테이너 설정
}
