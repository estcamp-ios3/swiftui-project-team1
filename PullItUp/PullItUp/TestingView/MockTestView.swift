//
//  MockTestView.swift
//  PullItUp
//
//  Created by 이지훈 on 7/7/25.
//

import SwiftUI

struct MockTestView: View {
    // 선택된 자격증 (부모 뷰로부터 전달받음)
    @Binding var selectedLicense: String?
    
    // 뷰 닫기 기능을 위한 환경 변수
    @Environment(\.dismiss) private var dismiss

    // 문제 리스트 (무작위로 60문제 선택)
    @State private var quizzes: [Quiz] = Array(quizListData.shuffled().prefix(60))
    
    // 현재 문제 인덱스
    @State private var currentIndex: Int = 0
    
    // 결과 화면 표시 여부
    @State private var showResult: Bool = false
    
    // 각 문제별로 선택한 보기 인덱스 저장 (선택 안했으면 nil)
    @State private var selectedOptionIndices: [Int?] = Array(repeating: nil, count: 60)
    
    // 제출 확인 팝업
    @State private var showSubmitAlert: Bool = false
    
    // 미응답 문제 안내 메시지
    @State private var showIncompleteMessage: Bool = false
    @State private var incompleteNumbers: [Int] = []
    
    // 종료 버튼 누를 때 확인 팝업
    @State private var showExitAlert: Bool = false
    
    // 경과 시간 (초 단위)
    @State private var elapsedTime: Int = 0
    
    // 타이머 동작 여부
    @State private var timerActive: Bool = true
    
    // 제한 시간 초과 팝업
    @State private var showTimeOverAlert: Bool = false

    // 총 시험 시간: 20분
    private let totalTime: Int = 20 * 60

    // 남은 시간 계산
    private var remainingTime: Int { max(totalTime - elapsedTime, 0) }

    // 진행률 (0~1)
    private var progress: Double { Double(remainingTime) / Double(totalTime) }

    // 정답 수 계산
    private var correctCount: Int {
        quizzes.enumerated().filter { index, quiz in
            guard let selected = selectedOptionIndices[index] else { return false }
            return quiz.options.indices.contains(selected) && quiz.options[selected] == quiz.answer
        }.count
    }

    // 오답 문제 번호 계산
    private var wrongNumbers: [Int] {
        quizzes.enumerated().compactMap { index, quiz in
            guard let selected = selectedOptionIndices[index], quiz.options.indices.contains(selected) else {
                return index + 1 // 미선택도 오답 처리
            }
            return quiz.options[selected] != quiz.answer ? index + 1 : nil
        }
    }

    // 시간 표시 형식 (MM:SS)
    private var formattedTime: String {
        let min = remainingTime / 60
        let sec = remainingTime % 60
        return String(format: "%02d:%02d", min, sec)
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    // 타이머 & 종료 버튼
                    if !showResult {
                        VStack(spacing: 0) {
                            HStack {
                                Spacer()
                                Button {
                                    showExitAlert = true
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 13)
                                .padding(.bottom, 10)
                                .alert("문제 풀기를 종료하시겠습니까?", isPresented: $showExitAlert) {
                                    Button("취소", role: .cancel) {}
                                    Button("확인", role: .destructive) { dismiss() }
                                }
                            }

                            // 타이머 진행 바
                            ProgressView(value: progress)
                                .progressViewStyle(
                                    LinearProgressViewStyle(
                                        tint: progress < 0.15 ? .red : .blue
                                    )
                                )
                                .frame(height: 6)
                                .padding(.horizontal, 16)

                            // 남은 시간 텍스트
                            Text("남은시간: \(formattedTime)")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .padding(.vertical, 5)
                        }
                    }

                    // 문제 영역 or 결과 영역
                    Group {
                        if showResult {
                            // 결과 화면
                            Spacer()
                            VStack(spacing: 24) {
                                Text("모의고사 결과")
                                    .font(.largeTitle).bold()
                                Text("\(correctCount)/\(quizzes.count)  \(Int(Double(correctCount) / Double(quizzes.count) * 100))%")
                                    .font(.title)

                                if !wrongNumbers.isEmpty {
                                    Text("틀린 문제: \(wrongNumbers.map { String($0) }.joined(separator: ", "))")
                                        .font(.body)
                                        .foregroundColor(.red)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                Text("소요시간: \(formattedTime)")
                                    .font(.title2)
                                    .foregroundColor(.blue)

                                Button("다시풀기") {
                                    resetAll()
                                }
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)

                                Button("메인으로") {
                                    dismiss()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            }
                            Spacer()
                        } else {
                            // 문제 푸는 화면
                            ScrollView {
                                VStack(alignment: .leading, spacing: 24) {
                                    HStack {
                                        Text("Q\(currentIndex+1)")
                                            .font(.title3.bold())
                                        Spacer()
                                        Text("\(currentIndex+1)/\(quizzes.count)")
                                            .foregroundColor(.secondary)
                                    }

                                    // 현재 문제 및 보기
                                    let quiz = quizzes[currentIndex]
                                    QuizDataView(
                                        quiz: quiz,
                                        selectedOptionIndex: Binding(
                                            get: { selectedOptionIndices[currentIndex] },
                                            set: { selectedOptionIndices[currentIndex] = $0 }
                                        )
                                    )

                                    Spacer(minLength: 100)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // 하단 버튼 영역
                if !showResult {
                    VStack(spacing: 12) {
                        if showIncompleteMessage {
                            Text("아직 풀지 않은 문제: \(incompleteNumbers.map { String($0 + 1) }.joined(separator: ", "))")
                                .font(.footnote)
                                .padding()
                                .background(Color.gray.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }

                        HStack {
                            // 이전 문제
                            Button {
                                if currentIndex > 0 { currentIndex -= 1 }
                            } label: {
                                Image(systemName: "arrow.left.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(currentIndex == 0 ? .gray : .blue)
                            }
                            .disabled(currentIndex == 0)

                            Spacer()

                            // 다음 문제 or 제출
                            if currentIndex < quizzes.count - 1 {
                                Button {
                                    currentIndex += 1
                                } label: {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.blue)
                                }
                            } else {
                                Button {
                                    let unanswered = selectedOptionIndices.enumerated()
                                        .filter { $0.element == nil }
                                        .map { $0.offset }

                                    if unanswered.isEmpty {
                                        showSubmitAlert = true
                                    } else {
                                        incompleteNumbers = unanswered
                                        withAnimation {
                                            showIncompleteMessage = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                            withAnimation {
                                                showIncompleteMessage = false
                                            }
                                        }
                                    }
                                } label: {
                                    Text("제출")
                                        .font(.title3.bold())
                                        .frame(width: 50, height: 50)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(25)
                                }
                                .alert("제출 완료하시겠습니까?", isPresented: $showSubmitAlert) {
                                    Button("취소", role: .cancel) {}
                                    Button("제출", role: .destructive) {
                                        showResult = true
                                        timerActive = false
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                    .background(Color.white.ignoresSafeArea(edges: .bottom))
                }
            }
            .navigationTitle("모의고사 풀기")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .onAppear { startTimer() }
            .onDisappear { timerActive = false }
            .alert("시험 시간이 종료되었습니다", isPresented: $showTimeOverAlert) {
                Button("확인") {
                    showResult = true
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // 타이머 시작 함수
    private func startTimer() {
        timerActive = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            guard timerActive, !showResult else {
                timer.invalidate()
                return
            }
            elapsedTime += 1

            if elapsedTime >= totalTime {
                timer.invalidate()
                timerActive = false
                showTimeOverAlert = true
            }
        }
    }

    // 전체 리셋 (다시 풀기)
    private func resetAll() {
        quizzes = Array(quizListData.shuffled().prefix(60))
        currentIndex = 0
        showResult = false
        selectedOptionIndices = Array(repeating: nil, count: 60)
        elapsedTime = 0
        timerActive = true
        showSubmitAlert = false
        showIncompleteMessage = false
        showTimeOverAlert = false
        startTimer()
    }
}

// MARK: - 프리뷰
struct MockTestView_Previews: PreviewProvider {
    static var previews: some View {
        MockTestView(selectedLicense: .constant("운전면허"))
    }
}
