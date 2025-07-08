//
//  AdBannerSection.swift
//  PullItUp
//
//  Created by catharina J on 7/7/25.
//

import SwiftUI
import SafariServices

// SwiftUI에서 SafariServices의 SFSafariViewController 사용
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        return safariVC
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}

struct AdBannerSection: View {
    @State var viewModel = AdBannerViewModel()
    
    var body: some View {
        if let ad = viewModel.currentAd {
            Button(action: {
                viewModel.adTapped() // ViewModel의 랜덤 광고 메서드 호출
            }) {
                Image(ad.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            }
            
            // SafariView를 모달로 띄움
            .sheet(isPresented: $viewModel.showingSafariView) {
                SafariView(url: ad.targetURL)
                    .ignoresSafeArea() // 웹뷰가 안전 영역을 무시하고 전체 화면을 차지하도록
                    .onDisappear {
                        viewModel.safariViewDismissed() // 시트가 닫힐 때 ViewModel에 알림 (옵션)
                    }
            }
            .padding(.vertical) // 광고 주변에 여백 추가
        } else {
            // 광고가 없을 경우 표시할 placeholder (예: 로딩 스피너, 빈 공간)
            ProgressView() // 예시로 로딩 스피너 표시
                .frame(width: 300, height: 100)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.vertical)
        }
        
    }
}

#Preview {
    AdBannerSection()
    
}
