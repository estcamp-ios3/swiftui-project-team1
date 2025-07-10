//
//  QuizDataView.swift
//  PullItUp
//
//  Created by 이지훈 on 7/7/25.
//

import SwiftUI

/// 퀴즈 한 문항을 화면에 표시하는 뷰입니다.
/// - 선택지 버튼 및 정답 보기 기능을 포함합니다.
struct QuizDataView: View {
    let quiz: Quiz                      // 퀴즈 데이터 (질문, 보기, 정답 등)
    @Binding var selectedOptionIndex: Int?  // 선택한 보기 인덱스 (상위 뷰에서 바인딩으로 전달받음)
    var disabled: Bool = false         // 선택 비활성화 여부 (문제 제출 후 등)
    
    // 아래는 TenTestView에서만 사용하는 정답 표시용 속성
    var showAnswer: Bool = false
    var onCloseAnswer: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            // 문제 텍스트
            Text(quiz.question)
                .font(.title3)
                .padding(.bottom, 4)
            
            // 보기 버튼 목록
            ForEach(0..<quiz.options.count, id: \.self) { i in
                Button(action: {
                    selectedOptionIndex = i  // 버튼을 누르면 해당 보기 선택
                }) {
                    HStack {
                        // 보기 텍스트
                        Text("\(i+1). \(quiz.options[i])")
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        // 선택 여부에 따른 원형 아이콘
                        Image(systemName: selectedOptionIndex == i ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(selectedOptionIndex == i ? .blue : .gray)
                            .font(.title2)
                    }
                    .padding(.horizontal, 14)
                }
                .disabled(disabled)  // 비활성화 옵션 적용
            }

            // 정답 보기 영역 (TenTestView에서만 활성화)
            if showAnswer {
                VStack(alignment: .leading, spacing: 8) {
                    Text("정답")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    // 정답 번호와 텍스트 표시
                    if let idx = Int(quiz.answer), quiz.options.count >= idx {
                        Text("\(quiz.answer)번: \(quiz.options[idx-1])")
                            .font(.body)
                    }

                    // 정답 닫기 버튼 (콜백 실행)
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

// MARK: - 미리보기용 샘플 뷰
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
