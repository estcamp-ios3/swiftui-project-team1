//
//  MockTestView.swift
//  PullItUp
//
//  Created by 이지훈 on 7/7/25.
//

import SwiftUI

struct MockTestView: View {
    @State private var quizzes: [Quiz] = Array(quizListData.shuffled().prefix(60))
    @State private var currentIndex: Int = 0
    @State private var showResult: Bool = false
    @State private var selectedOptionIndices: [Int?] = Array(repeating: nil, count: 60)
    @State private var showSubmitAlert: Bool = false

    @State private var elapsedTime: Int = 0  // 카운트업이 아니라 경과시간(초)
    @State private var timerActive: Bool = true

    // 프로그래스바용
    private let totalTime: Int = 20 * 60 // 20분(1200초)
    private var remainingTime: Int { max(totalTime - elapsedTime, 0) }
    private var progress: Double { Double(remainingTime) / Double(totalTime) }

    private var isAllAnswered: Bool {
        !selectedOptionIndices.contains(where: { $0 == nil })
    }
    private var formattedTime: String {
        let min = remainingTime / 60
        let sec = remainingTime % 60
        return String(format: "%02d:%02d", min, sec)
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    if !showResult {
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
                                    .padding(.bottom, 10)
                                }
                            
                            // 프로그래스바
                            ProgressView(value: progress)
                                .progressViewStyle(LinearProgressViewStyle(tint: progress < 0.15 ? .red : .blue))
                                .frame(height: 6)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 1)
                                .animation(.easeInOut, value: progress)
                            
                            HStack {
                                Spacer()
                                Text("남은시간: \(formattedTime)")
                                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                                    .padding(.vertical, 5)
                                Spacer().frame(width: 16)
                            }
                        }
                    }

                    Group {
                        if showResult {
                            Spacer()
                            VStack(spacing: 24) {
                                Text("모의고사 결과")
                                    .font(.largeTitle).bold()
                                Text("문제 수: \(quizzes.count)")
                                    .font(.title)
                                Text("소요시간: \(formattedTime)")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                Button("처음으로 돌아가기") {
                                    resetAll()
                                }
                                .padding()
                                .background(Color.yellow)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                            }
                            Spacer()
                        } else if currentIndex < quizzes.count {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 24) {
                                    // 상단 Qn | n/60
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
                                                selectedOptionIndices[currentIndex] = newValue
                                            }
                                        )
                                    )
                                    .id(currentIndex)

                                    Spacer(minLength: 100)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // 하단 네비게이션 버튼 (제출 없음)
                if !showResult {
                    HStack {
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
                        Spacer()
                        // 다음 문제 버튼 (마지막 문제일 때 비활성)
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
                    .background(
                        Color(.systemBackground)
                            .opacity(0.98)
                            .ignoresSafeArea(edges: .bottom)
                    )
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
        quizzes = Array(quizListData.shuffled().prefix(60))
        currentIndex = 0
        showResult = false
        selectedOptionIndices = Array(repeating: nil, count: 60)
        elapsedTime = 0
        timerActive = true
        startTimer()
    }
}

// MARK: - 프리뷰
struct MockTestView_Previews: PreviewProvider {
    static var previews: some View {
        MockTestView()
    }
}
