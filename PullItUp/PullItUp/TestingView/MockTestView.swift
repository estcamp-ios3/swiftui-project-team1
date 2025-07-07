//
//  MockTestView.swift
//  PullItUp
//
//  Created by 이지훈 on 7/7/25.
//

import SwiftUI

struct MockTestView: View {
    @State private var countNumer: Int = 0
    private let totalCount: Int = 20 * 60
    private let count = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                VStack(alignment: .trailing) {
                    Button(action: {}) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.gray)
                            .padding(.trailing, 15)
                    }
                    
                    ProgressView(value: reversedProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .padding(.horizontal)
                    
                    Text("남은 시간 \(formatTime)")
                        .font(.subheadline)
                        .padding(.trailing, 20)
                    
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Q1.")
                            .font(.title)
                            .bold(true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("문제 내용")
                            .padding(.top, 10)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(count) { _ in
                if countNumer < totalCount {
                    countNumer += 1
                }
            }
        }
        HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left.circle.fill")
                        .resizable()
                        .frame(width: 45, height: 45)
                }
            
            Spacer().frame(width: 250)
            
                Button(action: {}) {
                    Image(systemName: "chevron.right.circle.fill")
                        .resizable()
                        .frame(width: 45, height: 45)
                }
        }
    }

    var formatTime: String {
        let remaining = totalCount - countNumer
        let minutes = remaining / 60
        let seconds = remaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var reversedProgress: Double {
        return Double(totalCount - countNumer) / Double(totalCount)
    }
}

#Preview {
    MockTestView()
}
