//
//  TenTestView.swift
//  PullItUp
//
//  Created by 이지훈 on 7/7/25.
//

import SwiftUI

struct TenTestView: View {
    @Binding var selectedLicense: String?  // 선택된 자격증 이름

    @State private var quizzes: [Quiz] = Array(quizListData.shuffled().prefix(10)) // 문제 10개 무작위로 선택
    @State private var currentIndex: Int = 0            // 현재 보고 있는 문제 번호
    @State private var showResult: Bool = false         // 결과 화면 표시 여부
    @State private var selectedOptionIndices: [Int?] = Array(repeating: nil, count: 10) // 각 문제에 대한 선택 저장
    @State private var elapsedTime: Int = 0             // 경과 시간 (초)
    @State private var timerActive: Bool = true         // 타이머 실행 여부
    @State private var showHint: Bool = false           // 해설 보기 화면 전환 여부
    @State private var showAnswerPopup: Bool = false    // 정답 확인 팝업 표시 여부
    @State private var answerRevealed: [Bool] = Array(repeating: false, count: 10) // 정답 공개 여부 저장
    @State private var showIncompleteMessage: Bool = false // 미응답 문제 알림 메시지 표시 여부
    @State private var incompleteNumbers: [Int] = []    // 미응답 문제 번호
    @State private var showSubmitAlert: Bool = false    // 제출 확인 알림
    @State private var showExitAlert: Bool = false      // 종료 확인 알림

    @Environment(\.dismiss) private var dismiss         // 뷰 종료를 위한 환경값

    // 경과 시간을 MM:SS 형식으로 표시
    private var formattedElapsed: String {
        let min = elapsedTime / 60
        let sec = elapsedTime % 60
        return String(format: "%02d:%02d", min, sec)
    }

    // 정답 개수 계산
    private var correctCount: Int {
        quizzes.enumerated().filter { index, quiz in
            if let selected = selectedOptionIndices[index] {
                return quiz.options[safe: selected] == quiz.options[safe: Int(quiz.answer) ?? -1]
            }
            return false
        }.count
    }

    // 오답 문제 번호 계산
    private var wrongNumbers: [Int] {
        quizzes.enumerated().compactMap { index, quiz in
            if let selected = selectedOptionIndices[index],
               quiz.options[safe: selected] != quiz.options[safe: Int(quiz.answer) ?? -1] {
                return index + 1
            }
            return nil
        }
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    // 상단 종료 버튼
                    HStack {
                        Spacer()
                        if !showResult {
                            Button(action: {
                                showExitAlert = true
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 13)
                            .alert("문제 풀기를 종료하시겠습니까?", isPresented: $showExitAlert) {
                                Button("취소", role: .cancel) {}
                                Button("확인", role: .destructive) {
                                    dismiss()
                                }
                            }
                        }
                    }

                    // 경과 시간 표시
                    if !showResult {
                        HStack {
                            Spacer()
                            Text("경과시간 : \(formattedElapsed)")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.primary)
                                .padding(.vertical, 12)
                            Spacer().frame(width: 16)
                        }
                    }

                    Group {
                        if showResult {
                            // 결과 화면
                            Spacer()
                            VStack(spacing: 24) {
                                Text("10문제 결과")
                                    .font(.largeTitle).bold()
                                Text("정답률: \(correctCount)/\(quizzes.count)  \(Int((Double(correctCount) / Double(quizzes.count)) * 100))%")
                                    .font(.title)
                                if !wrongNumbers.isEmpty {
                                    Text("틀린 문제: \(wrongNumbers.map { String($0) }.joined(separator: ", "))")
                                        .font(.largeTitle)
                                        .foregroundColor(.red)
                                        .multilineTextAlignment(.center)
                                }
                                Text("소요시간: \(formattedElapsed)")
                                    .font(.title2)
                                    .foregroundColor(.blue)

                                // 다시 풀기 버튼
                                Button("다시 풀기") {
                                    resetAll()
                                }
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)

                                // 메인으로 이동 버튼
                                Button("메인으로") {
                                    dismiss()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            }
                            Spacer()
                        } else if currentIndex < quizzes.count {
                            // 문제 풀이 화면
                            ScrollViewReader { proxy in
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 24) {
                                        // 문제 번호
                                        HStack {
                                            Text("Q\(currentIndex+1)")
                                                .font(.system(size: 24, weight: .bold))
                                            Spacer()
                                            Text("\(currentIndex+1)/\(quizzes.count)")
                                                .foregroundColor(.secondary)
                                        }

                                        // 현재 문제 표시
                                        let quiz = quizzes[currentIndex]
                                        QuizDataView(
                                            quiz: quiz,
                                            selectedOptionIndex: Binding(
                                                get: { selectedOptionIndices[currentIndex] },
                                                set: { newValue in
                                                    if !answerRevealed[currentIndex] {
                                                        selectedOptionIndices[currentIndex] = newValue
                                                    }
                                                }
                                            )
                                        )
                                        .id("quizView")

                                        // 정답 공개 시 표시
                                        if answerRevealed[currentIndex] {
                                            VStack {
                                                Text("정답: \(quiz.options[safe: Int(quiz.answer) ?? -1] ?? quiz.answer)")
                                                    .font(.title2).bold()
                                                    .padding()
                                                    .background(Color.blue.opacity(0.2))
                                                    .cornerRadius(14)
                                            }
                                            .id("answer")
                                            .transition(.opacity)
                                        }

                                        Spacer(minLength: 100)
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .onChange(of: answerRevealed[currentIndex]) { show in
                                    if show {
                                        withAnimation {
                                            proxy.scrollTo("answer", anchor: .bottom)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // 하단 버튼 영역
                if !showResult {
                    VStack(spacing: 12) {
                        // 미응답 알림 메시지
                        if showIncompleteMessage {
                            Text("아직 풀지 않은 문제: \(incompleteNumbers.map { String($0 + 1) }.joined(separator: ", "))")
                                .font(.footnote)
                                .padding(10)
                                .background(Color.gray.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }

                        HStack(spacing: 28) {
                            // 이전 문제 버튼
                            Button(action: {
                                if currentIndex > 0 { currentIndex -= 1 }
                            }) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(currentIndex == 0 ? .gray : .blue)
                            }
                            .disabled(currentIndex == 0)

                            // 해설 및 정답보기 버튼
                            HStack(spacing: 11) {
                                NavigationLink(
                                    destination: HintView(explanation: quizzes[currentIndex].explanation),
                                    isActive: $showHint
                                ) {
                                    Button(action: { showHint = true }) {
                                        Text("해설보기")
                                            .font(.title3)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 16)
                                            .background(Color.red)
                                            .cornerRadius(15)
                                    }
                                }

                                let isEnabled = selectedOptionIndices[currentIndex] != nil && !answerRevealed[currentIndex]
                                Button(action: {
                                    showAnswerPopup = true
                                }) {
                                    Text("정답보기")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 16)
                                        .background(isEnabled ? Color.blue : Color.blue.opacity(0.5))
                                        .cornerRadius(15)
                                }
                                .disabled(!isEnabled)
                                .alert(isPresented: $showAnswerPopup) {
                                    Alert(
                                        title: Text("정답을 확인하시면 선택한 답을 변경하실 수 없습니다"),
                                        primaryButton: .destructive(Text("그래도 볼꺼야")) {
                                            answerRevealed[currentIndex] = true
                                        },
                                        secondaryButton: .cancel(Text("안볼래"))
                                    )
                                }
                            }

                            // 다음 문제 or 제출 버튼
                            if currentIndex < quizzes.count - 1 {
                                Button(action: {
                                    currentIndex += 1
                                }) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.blue)
                                }
                            } else {
                                Button(action: {
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
                                }) {
                                    Text("제출")
                                        .font(.title2.bold())
                                        .frame(width: 50, height: 50)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(50)
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
                        .padding(.bottom, 18)
                        .padding(.horizontal, 18)
                    }
                }
            }
            .navigationTitle("기출문제 풀기")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .onAppear { startTimer() }
            .onDisappear { timerActive = false }
        }
        .navigationBarBackButtonHidden(true)
    }

    // 타이머 시작 함수
    private func startTimer() {
        timerActive = true
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if !timerActive || showResult {
                timer.invalidate()
                return
            }
            elapsedTime += 1
        }
    }

    // 모든 값 초기화 (다시풀기용)
    private func resetAll() {
        quizzes = Array(quizListData.shuffled().prefix(10))
        currentIndex = 0
        showResult = false
        selectedOptionIndices = Array(repeating: nil, count: 10)
        elapsedTime = 0
        timerActive = true
        answerRevealed = Array(repeating: false, count: 10)
        startTimer()
    }
}

// 배열 접근 시 인덱스 초과 방지용 확장
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// 프리뷰 화면
struct TenTestView_Previews: PreviewProvider {
    static var previews: some View {
        TenTestView(selectedLicense: .constant("정보처리기사"))
    }
}
