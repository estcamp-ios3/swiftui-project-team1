//
//  TenTestView.swift
//  PullItUp
//
//  Created by 이지훈 on 7/7/25.
//

import SwiftUI

struct TenTestView: View {
    @State private var quizzes: [Quiz] = Array(quizListData.shuffled().prefix(10))
    @State private var currentIndex: Int = 0
    @State private var showResult: Bool = false
    @State private var selectedOptionIndices: [Int?] = Array(repeating: nil, count: 10)
    @State private var elapsedTime: Int = 0
    @State private var timerActive: Bool = true
    @State private var showHint: Bool = false
    @State private var showAnswerPopup: Bool = false
    @State private var answerRevealed: [Bool] = Array(repeating: false, count: 10)
    @State private var showIncompleteMessage: Bool = false
    @State private var incompleteNumbers: [Int] = []
    @State private var showSubmitAlert: Bool = false
    @State private var showExitAlert: Bool = false  // 🔹 종료 확인용 Alert 상태 변수

    @Environment(\.dismiss) private var dismiss

    private var formattedElapsed: String {
        let min = elapsedTime / 60
        let sec = elapsedTime % 60
        return String(format: "%02d:%02d", min, sec)
    }

    private var correctCount: Int {
        quizzes.enumerated().filter { index, quiz in
            if let selected = selectedOptionIndices[index] {
                return quiz.options[safe: selected] == quiz.options[safe: Int(quiz.answer) ?? -1]
            }
            return false
        }.count
    }

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
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                Text("소요시간: \(formattedElapsed)")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                Button("다시 풀기") {
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
                        } else if currentIndex < quizzes.count {
                            ScrollViewReader { proxy in
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 24) {
                                        HStack {
                                            Text("Q\(currentIndex+1)")
                                                .font(.system(size: 24, weight: .bold))
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Text("\(currentIndex+1)/\(quizzes.count)")
                                                .font(.system(size: 17, weight: .bold))
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.top, 8)
                                        .padding(.bottom, 2)

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

                                        if answerRevealed[currentIndex] {
                                            VStack {
                                                Text("정답: \(quiz.options[safe: Int(quiz.answer) ?? -1] ?? quiz.answer)")
                                                    .font(.title2).bold()
                                                    .padding()
                                                    .frame(maxWidth: .infinity)
                                                    .background(Color(red: 0.51, green: 0.79, blue: 1.0).opacity(0.22))
                                                    .cornerRadius(14)
                                                    .padding(.bottom, 8)
                                            }
                                            .id("answer")
                                            .transition(.opacity)
                                        }

                                        Spacer(minLength: 100)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
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

                if !showResult {
                    VStack(spacing: 12) {
                        if showIncompleteMessage {
                            Text("아직 풀지 않은 문제: \(incompleteNumbers.map { String($0 + 1) }.joined(separator: ", "))")
                                .font(.footnote)
                                .padding(10)
                                .background(Color.gray.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .transition(.opacity)
                        }

                        HStack(spacing: 28) {
                            Button(action: {
                                if currentIndex > 0 { currentIndex -= 1 }
                            }) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(currentIndex == 0 ? .gray : .blue)
                            }
                            .disabled(currentIndex == 0)

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
                                            .background(Color(red: 1.0, green: 0.44, blue: 0.35))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(Color(red: 0.98, green: 0.52, blue: 0.32), lineWidth: 2)
                                            )
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
                                        .background(
                                            isEnabled ? Color(red: 0.25, green: 0.59, blue: 0.98) : Color(red: 0.51, green: 0.79, blue: 1.0)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 0.25, green: 0.59, blue: 0.98), lineWidth: 2)
                                        )
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
                                    let unanswered = selectedOptionIndices.enumerated().filter { $0.element == nil }.map { $0.offset }
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
            .navigationTitle("기출문제 풀기") // 내비게이션 타이틀 설정
            .navigationBarTitleDisplayMode(.inline) // 타이틀 표시 방식
            .navigationBarBackButtonHidden(true) // < Back 버튼 가리기
            .toolbar(.hidden, for: .tabBar) // 탭바 가리기
            .onAppear { startTimer() }
            .onDisappear { timerActive = false }
            .toolbar(.hidden, for: .tabBar)
        }
        .navigationBarBackButtonHidden(true)
    }

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

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct TenTestView_Previews: PreviewProvider {
    static var previews: some View {
        TenTestView()
    }
}
