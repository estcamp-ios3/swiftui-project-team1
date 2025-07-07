//
//  TenTestView.swift
//  PullItUp
//
//  Created by 이지훈 on 7/7/25.
//

import SwiftUI

struct TenTestView: View {

    @State private var timerCount: Int = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var showHint: Bool = false // 해설 보기
    @State private var showAnswer: Bool = false // 정답 보기

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                VStack(alignment: .trailing) {
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
                }

                Text("경과시간 \(formattedTime)")
                    .onReceive(timer) { _ in
                        timerCount += 1
                    }

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        QuizDataView()
                    }
                }
            }
        }

        VStack(spacing: 15) {
            VStack {
                if showHint {
                    Text("이게 해설이다!\n여기는 두줄 잘 나오나요")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .foregroundColor(.gray)
                        .background(Color(.gray).opacity(0.2))
                        .cornerRadius(10)
                } else if showAnswer {
                    Text("이게 정답이다!")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .foregroundColor(.gray)
                        .background(Color(.gray).opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 16)

            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left.circle.fill")
                        .resizable()
                        .frame(width: 45, height: 45)
                }

                Spacer().frame(width: 25)

                Button(action: {
                    if showHint {
                        showHint = false
                    } else {
                        showHint = true
                        showAnswer = false
                    }
                }) {
                    Text(showHint ? "해설 닫기" : "해설 보기")
                        .font(.headline)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer().frame(width: 16)

                Button(action: {
                    if showAnswer {
                        showAnswer = false
                    } else {
                        showAnswer = true
                        showHint = false
                    }
                }) {
                    Text(showAnswer ? "정답 닫기" : "정답 보기")
                        .font(.headline)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer().frame(width: 25)

                Button(action: {}) {
                    Image(systemName: "chevron.right.circle.fill")
                        .resizable()
                        .frame(width: 45, height: 45)
                }
            }
        }
    }

    var formattedTime: String {
        let minutes = timerCount / 60
        let seconds = timerCount % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    TenTestView()
}
