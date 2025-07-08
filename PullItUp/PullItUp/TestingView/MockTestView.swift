//
//  MockTestView.swift
//  PullItUp
//
//  Created by 이지훈 on 7/7/25.
//

import SwiftUI

struct MockTestView: View {
    @State private var timeElapsed = 0
    private let totalTime = 20 * 60
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var selectAnswer: Int? = nil
    @State private var isSelectionLocked = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 15)
                }

                ProgressView(value: Double(timeElapsed) / Double(totalTime))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .padding(.horizontal)

                Text("남은 시간 \(formattedTime)")
                    .font(.subheadline)
                    .padding(.trailing, 20)

                ScrollView {
                    QuizDataView(
                        quiz: quizLists[0],
                        selectAnswer: $selectAnswer,
                        isSelectionLocked: isSelectionLocked
                    )
                        .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(timer) { _ in
                if timeElapsed < totalTime {
                    timeElapsed += 1
                }
            }

            HStack {
                Button(action: {}) {
                    Image(systemName: "arrow.left.circle.fill")
                        .resizable()
                        .frame(width: 45, height: 45)
                }

                Spacer().frame(width: 20)

                Button(action: {
                    isSelectionLocked.toggle()
                }) {
                    Text(isSelectionLocked ? "정답 닫기" : "정답 보기")
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer().frame(width: 20)

                Button(action: {}) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 45, height: 45)
                }
            }
            .padding()
        }
    }

    var formattedTime: String {
        let remaining = totalTime - timeElapsed
        let minutes = remaining / 60
        let seconds = remaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    MockTestView()
}
