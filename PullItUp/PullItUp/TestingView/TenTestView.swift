//
//  TenTestView.swift
//  PullItUp
//
//  Created by 이지훈 on 7/7/25.
//

import SwiftUI

struct TenTestView: View {
    @State private var timerCount = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var showHint = false
    @State private var showAnswer = false
    @State private var currentIndex = 0
    @State private var selectedAnswers: [Int?] = Array(repeating: nil, count: quizLists.count)

    var currentQuiz: QuizList { quizLists[currentIndex] }
    var isFirst: Bool { currentIndex == 0 }
    var isLast: Bool { currentIndex == quizLists.count - 1 }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable().frame(width: 35, height: 35)
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 16)
                }

                Text("경과시간 \(formattedTime)")
                    .font(.headline)
                    .padding(.bottom, 10)
                    .onReceive(timer) { _ in timerCount += 1 }

                ScrollView {
                    QuizDataView(
                        quiz: currentQuiz,
                        selectAnswer: $selectedAnswers[currentIndex],
                        isSelectionLocked: showAnswer
                    )
                    .padding(.bottom, 20)
                }
                .navigationBarHidden(true)

                VStack(spacing: 15) {
                    if showHint {
                        Text(currentQuiz.qHint)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .foregroundColor(.gray)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
                    } else if showAnswer {
                        Text(currentQuiz.qTrueAnswer)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .foregroundColor(.gray)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
                    }

                    HStack {
                        Button {
                            if !isFirst {
                                currentIndex -= 1
                                resetStates()
                            }
                        } label: {
                            Image(systemName: "chevron.left.circle.fill")
                                .resizable().frame(width: 50, height: 50)
                                .opacity(isFirst ? 0.3 : 1)
                        }
                        .disabled(isFirst)

                        Spacer().frame(width: 28)

                        Button {
                            toggleHint()
                        } label: {
                            Text(showHint ? "해설 닫기" : "해설 보기")
                                .font(.headline)
                                .padding().background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Spacer().frame(width: 11)

                        Button {
                            toggleAnswer()
                        } label: {
                            Text(showAnswer ? "정답 닫기" : "정답 보기")
                                .font(.headline)
                                .padding().background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Spacer().frame(width: 28)

                        Button {
                            if isLast {
                                submitQuiz()
                            } else {
                                currentIndex += 1
                                resetStates()
                            }
                        } label: {
                            if isLast {
                                Text("제출")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            } else {
                                Image(systemName: "chevron.right.circle.fill")
                                    .resizable().frame(width: 50, height: 50)
                                    .opacity(isLast ? 0.3 : 1)
                            }
                        }
                        .disabled(showAnswer && isLast ? false : isLast)
                    }
                    .padding(.bottom, 15)
                }
            }
        }
    }

    private func toggleHint() {
        showHint.toggle()
        if showHint { showAnswer = false }
    }

    private func toggleAnswer() {
        showAnswer.toggle()
        if showAnswer { showHint = false }
    }

    private func resetStates() {
        showHint = false
        showAnswer = false
    }

    private func submitQuiz() {
        print("답변 제출 \(selectedAnswers)")
    }

    var formattedTime: String {
        let m = timerCount / 60
        let s = timerCount % 60
        return String(format: "%02d:%02d", m, s)
    }
}

#Preview {
    TenTestView()
}
