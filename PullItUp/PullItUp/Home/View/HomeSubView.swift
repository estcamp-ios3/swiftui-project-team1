//
//  HomeSubView.swift
//  PullItUp
//
//  Created by catharina J on 7/7/25.
//

import SwiftUI

struct HomeSubView: View {
    @Binding var selectedLicense: String?
    
    // 자격증 종류- dummy
    let licenses = ["정보처리기사", "정보보안기사", "산업안전기사"]
    
    var body: some View {
        VStack(spacing: 12) {
            if let license = selectedLicense {
                // 선택 후 UI
                VStack {
                    Spacer()
                    Spacer()
                    Text(license)
                        .font(.title)
                        .fontWeight(.bold)
                        .offset(y: selectedLicense != nil ? 0 : -50)
                      
                    Spacer()
                    Spacer()
                    Text("다른 자격증으로 변경하시겠어요?")
                        .foregroundColor(.gray)
                        .offset(y: selectedLicense != nil ? 0 : -30)
                    
                    Picker("자격증", selection: $selectedLicense) {
                        ForEach(licenses, id: \.self) { itemLicense in
                            Text(itemLicense).tag(Optional(itemLicense))
                        }
                    }
                    .pickerStyle(.menu)
                    .foregroundColor(.blue)
                }
                .frame(height: 120)
                .clipped()
                .animation(.easeInOut(duration: 0.2), value: selectedLicense)
                
            } else {
                // 선택 전 UI
                VStack(spacing: 20) {
                    Spacer()
                    Spacer()
                    Text("어떤 자격증 문제를 풀어볼까요?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .offset(y: selectedLicense != nil ? 0 : 70)
                    Spacer()
                    Spacer()
                    Text("자격증을 선택해주세요")
                        .foregroundColor(.gray)
                        .offset(y: selectedLicense != nil ? 0 : 10)
                    
                    Picker("자격증", selection:$selectedLicense ) {
                        Text("기능사 / 산업기사 / 기사").tag(nil as String?)
                        ForEach(licenses, id: \.self) {license in
                            Text(license).tag(Optional(license))
                        }
                    }
                    .pickerStyle(.menu)
                    .foregroundColor(.blue)
                    Spacer()
                }
                .frame(height: 560)
                .clipped()
                .animation(.easeInOut(duration: 0.2), value: selectedLicense)
            }
            
        }
        .layoutPriority(1)    }
}

#Preview {
    HomeSubView(selectedLicense: .constant(nil))
}
