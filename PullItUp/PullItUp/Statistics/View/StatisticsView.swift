//
//  StatisticsView.swift
//  PullItUp
//
//  Created by J on 7/8/25.
//

import SwiftUI
import SwiftData
import Charts


struct StatisticsView: View {
    @Environment(\.modelContext) private var context
    
    @State private var allSessions: [QuizSession] = []
    @State private var selectedLicense: String = ""
    @State private var selectedSession: QuizSession? = nil
    
    var selectedAccuracies: [SubjectAccuracy] {
        // 현재 선택된 퀴즈 세션의 정답률 정보
        selectedSession?.subjectAccuracies ?? []
    }
    
    var filteredSessions: [QuizSession] {
        // 전체 퀴즈 세션 중, 피커로 과목이 선택된 세션
        allSessions.filter { $0.licenseName == selectedLicense }
    }
    
    var licenseNames: [String] {
        // 전체 퀴즈 세션 중, 자격증 이름 중복 제거
        Set(allSessions.map { $0.licenseName }).sorted()
    }
    
    
    var body: some View {
        VStack(spacing: 16) {
            if selectedAccuracies.isEmpty {
                // 불러온 퀴즈 세션의 정답률 정보(퀴즈 세션 자체가) 비어 있다면
                Spacer()
                
                Text("최근 퀴즈 결과가 없습니다.")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                // 뷰 타이틀 설정
                Text("과목 별 정답률 통계")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)
                
                // 방사형 차트 그리기
                RadarChart(
                    data: selectedAccuracies.map { $0.accuracy },
                    labels: selectedAccuracies.map { $0.subject },
                    maxValues: Array(repeating: 1.0, count: selectedAccuracies.count),
                    shapeColor: .orange,
                    radius: 100
                )
                .padding(.bottom, 20)
                
                // 과목 별 정답률 표시
                ForEach(selectedAccuracies) { item in
                    HStack {
                        Text(item.subject)
                        Spacer()
                        Text("\(Int(item.accuracy * 100))%")
                    }
                    .padding(.horizontal)
                }
            }
            
            
            Grid(alignment: .leading, horizontalSpacing: 20) {
                if !licenseNames.isEmpty {
                    GridRow {
                        Text("자격증 선택")
                            .font(.headline)
                        
                        Picker("자격증 선택", selection: $selectedLicense) {
                            ForEach(licenseNames, id: \.self) { license in
                                Text(license)
                                    .tag(license)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedLicense) {
                            // 라이선스가 바뀌면 해당하는 세션 중 가장 최신 날짜로 자동 선택
                            let latest = allSessions
                                .filter { $0.licenseName == selectedLicense }
                                .sorted(by: { $0.startedAt > $1.startedAt })
                                .first
                            
                            selectedSession = latest
                        }
                    }
                }
                
                if !filteredSessions.isEmpty,
                   let selected = selectedSession,
                   filteredSessions.contains(where: { $0.id == selected.id }) {
                    GridRow {
                        Text("날짜 선택")
                            .font(.headline)
                        
                        Picker("날짜 선택", selection: $selectedSession) {
                            ForEach(filteredSessions, id: \.self) { session in
                                Text(formattedDate(session.startedAt))
                                    .tag((session as QuizSession?) ?? QuizSession(licenseName: "", quizType: .short))
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .padding(.top, 30)
            
            Spacer()
        }
        .padding()
        .navigationTitle("과목별 정답률")
        .onAppear {
            // loadAllSessions() // 더미 데이터 미사용 시, 해당 라인 주석 해제
            allSessions = dummySessions
            
            // 최초 노출 자격증 값 지정
            if let firstLicense = allSessions.first?.licenseName {
                selectedLicense = firstLicense
                updateLatestSession(for: firstLicense)
            }
        }
    }
    
    
    func updateLatestSession(for license: String) {
        // 제일 최근 날짜로 설정
        let filtered = allSessions
            .filter { $0.licenseName == license }
            .sorted { $0.startedAt > $1.startedAt }
        
        selectedSession = filtered.first
    }
    
    func loadAllSessions() {
        // 종료된 모든 퀴즈 세션을 불러오기
        let descriptor = FetchDescriptor<QuizSession>(
            predicate: #Predicate { $0.endedAt != nil },
            sortBy: [SortDescriptor(\.startedAt, order: .reverse)]
        )
        
        do {
            allSessions = try context.fetch(descriptor)
            
            // 자격증 목록 업데이트
            if let firstLicense = licenseNames.first {
                selectedLicense = firstLicense
                updateLatestSession(for: firstLicense)
            }
        } catch {
            print("세션 로딩 실패: \(error)")
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        // 날짜 형식 포멧 셋팅
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd (E)"
        
        return formatter.string(from: date)
    }
    
    
    // MARK: - Dummy Answer 생성 함수
    func makeDummyAnswers(
        subject: String,
        correctCount: Int,
        totalCount: Int,
        session: QuizSession
    ) -> [QuizAnswer] {
        let correct = (0..<correctCount).map { i in
            QuizAnswer(
                questionNumber: i + 1,
                quizItemID: UUID(),
                subject: subject,
                selectedAnswer: "1",
                isCorrect: true,
                session: session
            )
        }
        let incorrect = (correctCount..<totalCount).map { i in
            QuizAnswer(
                questionNumber: i + 1,
                quizItemID: UUID(),
                subject: subject,
                selectedAnswer: "2",
                isCorrect: false,
                session: session
            )
        }
        return correct + incorrect
    }
    
    // MARK: - 통계 테스트용 Dummy 세션 목록
    var dummySessions: [QuizSession] {
        [
            {
                let session = QuizSession(
                    licenseName: "식품기사",
                    quizType: .short,
                    startedAt: Date().addingTimeInterval(-86400 * 2)
                )
                session.endedAt = session.startedAt.addingTimeInterval(600)
                
                session.answers = makeDummyAnswers(
                    subject: "식품위생학",
                    correctCount: 4,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "식품화학",
                    correctCount: 5,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "식품가공학",
                    correctCount: 3,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "식품미생물학",
                    correctCount: 9,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "생화학 및 발효학",
                    correctCount: 1,
                    totalCount: 10,
                    session: session
                )
                
                return session
            }(),
            {
                let session = QuizSession(
                    licenseName: "정보처리기사",
                    quizType: .short,
                    startedAt: Date().addingTimeInterval(-86400 * 2)
                )
                session.endedAt = session.startedAt.addingTimeInterval(600)
                
                session.answers = makeDummyAnswers(
                    subject: "소프트웨어 설계",
                    correctCount: 1,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "정보보호",
                    correctCount: 2,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "데이터베이스 구축",
                    correctCount: 3,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "프로그래밍 언어 활용",
                    correctCount: 4,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "애플리케이션 테스트",
                    correctCount: 5,
                    totalCount: 10,
                    session: session
                )
                
                return session
            }(),
            {
                let session = QuizSession(
                    licenseName: "정보처리기사",
                    quizType: .long,
                    startedAt: Date().addingTimeInterval(-86400)
                )
                session.endedAt = session.startedAt.addingTimeInterval(800)
                
                session.answers = makeDummyAnswers(
                    subject: "소프트웨어 설계",
                    correctCount: 3,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "정보보호",
                    correctCount: 4,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "데이터베이스 구축",
                    correctCount: 5,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "프로그래밍 언어 활용",
                    correctCount: 6,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "애플리케이션 테스트",
                    correctCount: 7,
                    totalCount: 10,
                    session: session
                )
                
                return session
            }(),
            {
                let session = QuizSession(
                    licenseName: "정보처리기사",
                    quizType: .short,
                    startedAt: Date()
                )
                session.endedAt = session.startedAt.addingTimeInterval(700)
                
                session.answers = makeDummyAnswers(
                    subject: "소프트웨어 설계",
                    correctCount: 8,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "정보보호",
                    correctCount: 9,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "데이터베이스 구축",
                    correctCount: 7,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "프로그래밍 언어 활용",
                    correctCount: 8,
                    totalCount: 10,
                    session: session
                ) + makeDummyAnswers(
                    subject: "애플리케이션 테스트",
                    correctCount: 10,
                    totalCount: 10,
                    session: session
                )
                
                return session
            }()
        ]
    }
}

#Preview {
    StatisticsView()
}
