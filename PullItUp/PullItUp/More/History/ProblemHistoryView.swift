//
//  ProblemHistoryView.swift
//  PullItUp
//
//  Created by suji chae on 7/8/25.
//

import SwiftUI
import SwiftData

struct ProblemHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ProblemSession.date, order: .reverse) private var sessions: [ProblemSession]

    // 날짜별로 세션을 그룹화하고 최신순으로 정렬
    private var groupedSessions: [Date: [ProblemSession]] {
        Dictionary(grouping: sessions) { session in
            Calendar.current.startOfDay(for: session.date)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                // 가장 최신 날짜부터 정렬하여 섹션 생성
                ForEach(groupedSessions.keys.sorted(by: >), id: \.self) { date in
                    Section(header: Text(date, formatter: dateFormatter)) {
                        // 각 날짜 내에서는 회차(sessionNumber) 순으로 정렬
                        ForEach(groupedSessions[date]!.sorted(by: { $0.sessionNumber < $1.sessionNumber })) { session in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(session.sessionNumber)회차")
                                        .font(.headline)
                                    Text(session.isCompleted ? "완료" : "미완료")
                                        .font(.subheadline)
                                        .foregroundColor(session.isCompleted ? .green : .red)
                                }
                                Spacer()
                                Text("\(session.scoreNumerator)/\(session.scoreDenominator)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
            }
            .navigationTitle("문제풀이이력")
            .onAppear {
                if sessions.isEmpty {
                    addSampleData()
                }
            }
        }
    }

    // 날짜 포맷터
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long // 예: 2025년 6월 24일
        formatter.timeStyle = .none
        return formatter
    }

    // addSampleData : 앱을 처음 켰을 때 보여줄 가짜 기록들을 넣어주는 부분이에요.
    private func addSampleData() {
        let calendar = Calendar.current

        // 2025.06.21 날짜의 기록들
        modelContext.insert(ProblemSession(date: calendar.date(from: DateComponents(year: 2025, month: 6, day: 21))!, sessionNumber: 1, quizType: .short, scoreNumerator: 5, scoreDenominator: 10, isCompleted: false)) // 1회차, 5/10, 미완료
        modelContext.insert(ProblemSession(date: calendar.date(from: DateComponents(year: 2025, month: 6, day: 21))!, sessionNumber: 2, quizType: .short, scoreNumerator: 10, scoreDenominator: 10, isCompleted: true)) // 2회차, 10/10, 완료

        // 2025.06.22 날짜의 기록들
        modelContext.insert(ProblemSession(date: calendar.date(from: DateComponents(year: 2025, month: 6, day: 22))!, sessionNumber: 1, quizType: .long, scoreNumerator: 20, scoreDenominator: 20, isCompleted: true)) // 1회차, 20/20, 완료


        modelContext.insert(ProblemSession(date: calendar.date(from: DateComponents(year: 2025, month: 6, day: 23))!, sessionNumber: 1, quizType: .short, scoreNumerator: 5, scoreDenominator: 10, isCompleted: false))
        modelContext.insert(ProblemSession(date: calendar.date(from: DateComponents(year: 2025, month: 6, day: 23))!, sessionNumber: 2, quizType: .long, scoreNumerator: 20, scoreDenominator: 20, isCompleted: true))
        modelContext.insert(ProblemSession(date: calendar.date(from: DateComponents(year: 2025, month: 6, day: 23))!, sessionNumber: 3, quizType: .short, scoreNumerator: 10, scoreDenominator: 10, isCompleted: true))

        modelContext.insert(ProblemSession(date: calendar.date(from: DateComponents(year: 2025, month: 6, day: 24))!, sessionNumber: 1, quizType: .long, scoreNumerator: 20, scoreDenominator: 20, isCompleted: true))
    }
}

#Preview {
    NavigationStack {
        ProblemHistoryView()
            .modelContainer(for: ProblemSession.self, inMemory: true) // 미리보기용 SwiftData 컨테이너 설정
    }
}

