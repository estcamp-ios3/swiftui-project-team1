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
    @State private var currentIndex = 0

    @State private var selectedAnswers: [Int?] = Array(repeating: nil, count: quizLists.count)
    @State private var hasShownAnswerAlert: [Bool] = Array(repeating: false, count: quizLists.count)
    @State private var showAnswerAlert = false

    var currentQuiz: QuizList { quizLists[currentIndex] }
    var isFirst: Bool { currentIndex == 0 }
    var isLast: Bool { currentIndex == quizLists.count - 1 }
    var hasAnsweredCurrent: Bool { selectedAnswers[currentIndex] != nil }
    var hasSeenAnswerCurrent: Bool { hasShownAnswerAlert[currentIndex] }
    var allAnswered: Bool { selectedAnswers.allSatisfy { $0 != nil } }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button {} label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable().frame(width: 35, height: 35)
                            .foregroundColor(.gray)
                    }.padding(.trailing, 16)
                }
                Text("경과시간 \(formattedTime)")
                    .font(.headline)
                    .padding(.bottom, 10)
                    .onReceive(timer) { _ in timerCount += 1 }

                ScrollView {
                    QuizDataView(
                        quiz: currentQuiz,
                        selectAnswer: $selectedAnswers[currentIndex],
                        isSelectionLocked: hasSeenAnswerCurrent
                    )
                    .padding(.bottom, 20)
                }.navigationBarHidden(true)

                VStack(spacing: 15) {
                    if showHint {
                        Text(currentQuiz.qHint)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding().foregroundColor(.gray)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
                    }
                    if hasSeenAnswerCurrent {
                        Text(currentQuiz.qTrueAnswer)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding().foregroundColor(.gray)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
                    }

                    HStack {
                        Button {
                            if currentIndex > 0 {
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
                            showHint.toggle()
                        } label: {
                            Text(showHint ? "해설 닫기" : "해설 보기")
                                .font(.headline)
                                .padding().background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Spacer().frame(width: 11)

                        Button {
                            if !hasSeenAnswerCurrent {
                                showAnswerAlert = true
                            }
                        } label: {
                            Text(hasSeenAnswerCurrent ? "정답 확인" : "정답 보기")
                                .font(.headline)
                                .padding()
                                .background(hasAnsweredCurrent ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(!hasAnsweredCurrent || hasSeenAnswerCurrent)
                        .opacity((!hasAnsweredCurrent || hasSeenAnswerCurrent) ? 0.5 : 1)
                        .alert(isPresented: $showAnswerAlert) {
                            Alert(
                                title: Text("정답 확인"),
                                message: Text("정답을 확인 하시겠습니까?\n정답 확인 후 선택은 변경할 수 없습니다."),
                                primaryButton: .cancel(Text("취소")),
                                secondaryButton: .default(Text("확인")) {
                                    hasShownAnswerAlert[currentIndex] = true
                                    showHint = false
                                }
                            )
                        }

                        Spacer().frame(width: 28)

                        Button {
                            if isLast {
                                // 제출 로직
                                print("제출:", selectedAnswers)
                            } else {
                                currentIndex += 1
                                resetStates()
                            }
                        } label: {
                            if isLast {
                                Text("제출")
                                    .font(.headline)
                                    .padding()
                                    .background(allAnswered ? Color.green : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            } else {
                                Image(systemName: "chevron.right.circle.fill")
                                    .resizable().frame(width: 50, height: 50)
                            }
                        }
                        .disabled(isLast && !allAnswered)
                    }
                    .padding(.bottom, 15)
                }
            }
        }
    }

    private func resetStates() {
        showHint = false
        showAnswerAlert = false
    }

    private var formattedTime: String {
        let m = timerCount / 60
        let s = timerCount % 60
        return String(format: "%02d:%02d", m, s)
    }
}

struct TenTestView_Previews: PreviewProvider {
    static var previews: some View {
        TenTestView()
    }
}
