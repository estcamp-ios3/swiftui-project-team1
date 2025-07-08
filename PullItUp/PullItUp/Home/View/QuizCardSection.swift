//
//  QuizCardSection.swift
//  PullItUp
//
//  Created by catharina J on 7/7/25.
//

import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .padding(.horizontal, 1)
            .frame(maxWidth: .infinity)
            .background(Color.secondary.opacity(0.2))
            .cornerRadius(12)
            .buttonStyle(.plain)
    }
}

struct QuizCardSection: View {
    // 10문제 풀기 시트 표시 여부
    @State private var showingTenTestView: Bool = false
    // 모의고사 풀기 시트 표시 여부
    @State private var showingMockTestView: Bool = false
    
    var body: some View {
        VStack{
            Text("어떤 유형으로 풀어볼까요?")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 8)
                .padding(.top, 16)
            HStack {
                //기출문제 바로가기
                NavigationLink{
                    TenTestView()
                } label:{
                    HStack(alignment:.bottom) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("기출문제")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            Text("10문제씩 풀기")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                        
                    }
                    .cardStyle()
                }
                
                
                //모의고사 바로가기
                NavigationLink{
                    MockTestView()
                } label:{
                    HStack(alignment:.bottom) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("모의고사")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            Text("60문제 한번에 풀기")
                                .font(.body)
                                .lineLimit(1)
                                .kerning(-0.75)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .cardStyle()
                }
            }
        }
    }
}

#Preview {
    QuizCardSection()
}
