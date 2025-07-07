//
//  QuizCardSection.swift
//  PullItUp
//
//  Created by catharina J on 7/7/25.
//

import SwiftUI

extension View {
    // 여기에 카드 스타일 공통으로 쓰고 싶음
    func cardStyle() -> some View {
        self
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(12)
    }
}

struct QuizCardSection: View {
    var body: some View {
        VStack{
            Text("어떤 유형으로 풀어볼까요?")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 12)
            HStack {
                HStack(alignment:.bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("기출문제")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        Text("10문제씩 풀기")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .padding(5)
                }
                .cardStyle()
                
                HStack(alignment:.bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("모의고사")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        Text("60문제 풀기")
                            .font(.title3)
                            .lineLimit(1)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .padding(5)
                }
                .cardStyle()
            }
        }
    }
}

#Preview {
    QuizCardSection()
}
