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

    // 정답보기 관련 State
    @State private var showAnswerPopup: Bool = false
    @State private var answerRevealed: [Bool] = Array(repeating: false, count: 10)

    private var isAllAnswered: Bool {
        !selectedOptionIndices.contains(where: { $0 == nil })
    }
    private var formattedElapsed: String {
        let min = elapsedTime / 60
        let sec = elapsedTime % 60
        return String(format: "%02d:%02d", min, sec)
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                
                VStack(spacing: 0) {
                    
                    HStack {
                            Spacer()
                            Button(action: {
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 13)
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
                                Text("문제 수: \(quizzes.count)")
                                    .font(.title)
                                Text("소요시간: \(formattedElapsed)")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                Button("다시 풀기") {
                                    resetAll()
                                }
                                .padding()
                                .background(Color.yellow)
                                .foregroundColor(.black)
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

                                        // 정답 토글 박스 (정답보기 버튼 바로 위)
                                        if answerRevealed[currentIndex] {
                                            VStack {
                                                Text("정답: \(quiz.options[safe: Int(quiz.answer) ?? -1] ?? quiz.answer)")
                                                    .font(.title2).bold()
                                                    .padding()
                                                    .frame(maxWidth: .infinity)
                                                    .background(Color(red: 0.51, green: 0.79, blue: 1.0).opacity(0.22)) // 버튼색 참고
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

                // 하단 네비 + 해설/정답 버튼(가운데) (스타일/색상/폰트 모두 "첨부 파일 그대로")
                if !showResult {
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


                        // 해설/정답 버튼 가로로 (색상, 폰트, 패딩 모두 첨부파일과 동일!)
                        HStack(spacing: 11) {
                            // 해설보기: 피치핑크
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
                            // 정답보기: 밝은 블루 + 기능
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
                                            isEnabled
                                            ? Color(red: 0.25, green: 0.59, blue: 0.98) // 진한 블루
                                            : Color(red: 0.51, green: 0.79, blue: 1.0)  // 기존 밝은 블루
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


                        // 다음 문제 버튼 (마지막 문제면 비활성)
                        Button(action: {
                            if currentIndex < quizzes.count - 1 {
                                currentIndex += 1
                            }
                        }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(currentIndex == quizzes.count - 1 ? .gray : .blue)
                        }
                        .disabled(currentIndex == quizzes.count - 1)
                    }
                    .padding(.bottom, 18)
                    .padding(.horizontal, 18)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear { startTimer() }
            .onDisappear { timerActive = false }
        }
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

// MARK: - 옵션 배열 접근 안전하게 (범위 벗어나면 nil)
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - 프리뷰
struct TenTestView_Previews: PreviewProvider {
    static var previews: some View {
        TenTestView()
    }
}
