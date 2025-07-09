//
//  QuizDataView.swift
//  PullItUp
//
//  Created by 이지훈 on 7/7/25.
//

import SwiftUI

struct QuizDataView: View {
    let quiz: Quiz
    @Binding var selectedOptionIndex: Int?
    var disabled: Bool = false

    // 아래 showAnswer 등은 TenTestView에서만 사용합니다.
    var showAnswer: Bool = false
    var onCloseAnswer: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(quiz.question)
                .font(.title3)
                .padding(.bottom, 4)
            
            ForEach(0..<quiz.options.count, id: \.self) { i in
                Button(action: {
                    selectedOptionIndex = i
                }) {
                    HStack {
                        Text("\(i+1). \(quiz.options[i])")
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: selectedOptionIndex == i ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(selectedOptionIndex == i ? .blue : .gray)
                            .font(.title2)
                    }
                    .padding(.horizontal, 14)
                }
                .disabled(disabled)
            }
            // TenTestView에서 showAnswer 지원 시 하단에 정답 안내
            if showAnswer {
                VStack(alignment: .leading, spacing: 8) {
                    Text("정답")
                        .font(.headline)
                        .foregroundColor(.green)
                    if let idx = Int(quiz.answer), quiz.options.count >= idx {
                        Text("\(quiz.answer)번: \(quiz.options[idx-1])")
                            .font(.body)
                    }
                    if let onClose = onCloseAnswer {
                        Button("정답닫기") {
                            onClose()
                        }
                        .font(.callout).bold()
                        .foregroundColor(.green)
                        .padding(.top, 2)
                    }
                }
                .padding()
                .background(Color(.systemGreen).opacity(0.09))
                .cornerRadius(14)
                .padding(.top, 8)
                .transition(.opacity)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 2)
    }
}

// MARK: - 프리뷰
struct QuizDataView_Previews: PreviewProvider {
    @State static var selectedOptionIndex: Int? = nil

    static var previews: some View {
        QuizDataView(
            quiz: Quiz(
                number: 1,
                question: "프리뷰: SwiftUI 문제 영역에 Qn/진행 표시 적용하기",
                options: ["옵션1이 장문일때 글자를 정렬하기 위해서 어떻게 해야하나", "옵션2", "옵션3", "옵션4"],
                answer: "2",
                explanation: "여기 해설 내용이 들어갑니다.",
                subject: "프리뷰"
            ),
            selectedOptionIndex: $selectedOptionIndex
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
