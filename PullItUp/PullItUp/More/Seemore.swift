//
//  Seemore.swift
//  PullItUp
//
//  Created by suji chae on 7/6/25.
//

import SwiftUI

struct Seemore: View {
    var body: some View {
        NavigationStack { // NavigationStack을 사용하여 전체 뷰 계층 관리
            List {
                // 첫 번째 항목: 문제풀이 이력
                NavigationLink(destination: ProblemHistoryView()) { // HistoryView()로 대체 필요
                    HStack {
                        Text("문제풀이 이력")
                        Spacer() // 텍스트를 왼쪽에 정렬하고 오른쪽에 화살표를 붙임
                    }
                    .font(.headline)


                }

                // 두 번째 항목: 원서접수 안내
                NavigationLink(destination: Reception()) {
                    HStack {
                        Text("원서접수 안내")
                        Spacer()
                    }
                    .font(.headline)
                }
            }
            .navigationTitle(Text("더보기")) // 상단 타이틀
            .navigationBarTitleDisplayMode(.automatic) // 타이틀 표시 모드
        }
    }
}

#Preview {
    // 미리보기에서는 NavigationStack으로 감싸야 NavigationLink가 올바르게 작동합니다.
    NavigationStack {
        Seemore()
    }
}
