//
//  HomeView.swift
//  PullItUp
//
//  Created by catharina J on 7/7/25.
//

import SwiftUI

struct HomeView: View {
    // 자격증 선택
    @State private var selectedLicense: String? = nil  // nil이면 미선택 상태
    @State private var showSections: Bool = true
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        VStack(spacing: 0) {
                            
                            // 자격증 선택 뷰
                            HomeSubView(selectedLicense: $selectedLicense)
                            
                            Image("homeBg")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 150)
                            
                            if showSections {
                                VStack(spacing: 32) {
                                    
                                    QuizCardSection() // 문제풀이 버튼 뷰
                                    
                                    AdBannerSection() // 광고 배너 뷰
                                    
                                    LicenseInfoSection() // 원서접수안내 뷰
                                    
                                    HistorySection() // 이력관리 뷰
                                }
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 0.3), value: showSections)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                        
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: selectedLicense)
                    
                }
            }
            .background(Color.white)
            .onChange(of: selectedLicense) {
                withAnimation {
                    showSections = (selectedLicense != nil)
                }
            }
            //scrollView
        }
    }
}

#Preview {
    HomeView()
}
