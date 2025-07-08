//
//  HomeView.swift
//  PullItUp
//
//  Created by catharina J on 7/7/25.
//

import SwiftUI
import SwiftData

// 앱 전체의 내비게이션 목적지를 정의
enum AppNavigationPath: Hashable {
    // TenTestView로 이동할 때
    case tenTest
    // MockTestView로 이동할 때
    case mockTest
}

struct HomeView: View {
    // 자격증 선택
    @State private var selectedLicense: String? = nil  // nil이면 미선택 상태
    @State private var showSections: Bool = true
    
    // NavigationStack의 경로 관리할 상태 변수
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        VStack(spacing: 0) {
                            
                            // 자격증 선택 뷰
                            HomeSubView(selectedLicense: $selectedLicense)
                            
                            Image("homeBg")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 120)
                            
                            if showSections {
                                VStack(spacing: 24) {
                                    
                                    QuizCardSection(selectedLicense: $selectedLicense) // 문제풀이 버튼 뷰
                                    
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
            // path의 값에 따라 뷰를 매핑
            .navigationDestination(for: AppNavigationPath.self) { destinationPath in
                switch destinationPath {
                case .tenTest:
                    TenTestView(selectedLicense: $selectedLicense)
                case .mockTest:
                    MockTestView(selectedLicense: $selectedLicense)
                }
            }
        }
       
    }
}

#Preview {
    HomeView()
}
