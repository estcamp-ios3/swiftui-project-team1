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
    //HomeView의 @State 변수 바인딩
    @Binding var selectedLicense: String?
    
    // 10문제 풀기 시트 표시 여부
//    @State private var showingTenTestView: Bool = false
    // 모의고사 풀기 시트 표시 여부
//    @State private var showingMockTestView: Bool = false
    
    var body: some View {
        VStack{
            Text("어떤 유형으로 풀어볼까요?")
                .font(.system(size: 28))
                .fontWeight(.bold)
                .opacity(0.9)
                .padding(.bottom, 8)
                .padding(.top, 20)
            HStack {
                
                //기출문제 바로가기
                NavigationLink(value: AppNavigationPath.tenTest){
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("기출문제")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                    .opacity(0.8)
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
                NavigationLink(value: AppNavigationPath.mockTest){
                    HStack(alignment:.bottom) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("모의고사")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .opacity(0.8)
                            Text("한번에 풀기")
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
    QuizCardSection(selectedLicense: .constant("운전면허"))
}
