//
//  QuizDataView.swift
//  PullItUp
//
//  Created by 이지훈 on 7/7/25.
//

import SwiftUI

struct QuizDataView: View {
    var quiz: QuizList
    @Binding var selectAnswer: Int?
    var isSelectionLocked: Bool

    var answers: [String] {
        [quiz.qAnswer1, quiz.qAnswer2, quiz.qAnswer3, quiz.qAnswer4]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(quiz.qNumber)
                .font(.title2).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

            Text(quiz.qText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

            VStack(spacing: 12) {
                ForEach(0..<answers.count, id: \.self) { idx in
                    Button {
                        if !isSelectionLocked {
                            selectAnswer = idx
                        }
                    } label: {
                        HStack {
                            Text("\(idx + 1). \(answers[idx])")
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(
                                systemName: selectAnswer == idx ? "largecircle.fill.circle" : "circle"
                            )
                            .foregroundColor(selectAnswer == idx ? .blue : .gray)
                            Spacer()
                        }
                        .padding(13)
                        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

struct QuizDataView_Previews: PreviewProvider {
    static var previews: some View {
        QuizDataView(quiz: quizLists[0], selectAnswer: .constant(nil), isSelectionLocked: false)
    }
}
