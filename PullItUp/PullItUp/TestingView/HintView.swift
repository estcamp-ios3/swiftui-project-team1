//
//  HintView.swift
//  PullItUp
//
//  Created by 이지훈 on 7/8/25.
//

import SwiftUI

struct HintView: View {
    let explanation: String

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Text("해설")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                ScrollView {
                    Text(explanation)
                        .font(.body)
                        .padding()
                }
                Spacer()
            }
            .padding()
            .navigationTitle("해설보기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - 프리뷰
struct HintView_Previews: PreviewProvider {
    static var previews: some View {
        HintView(explanation: "이곳에 해설 내용을 입력하세요. 여러 줄의 긴 해설도 스크롤로 볼 수 있습니다.")
    }
}
