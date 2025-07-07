//
//  AdBannerSection.swift
//  PullItUp
//
//  Created by catharina J on 7/7/25.
//

import SwiftUI
import SafariServices

/// 개별 광고의 이미지 이름과 연결될 URL을 정의하는 구조체
struct AdData: Identifiable {
    let id = UUID() // 각 광고를 고유하게 식별하기 위한 ID
    let imageName: String // 앱 내 Assets.xcassets에 있는 이미지 이름
    let targetURL: URL // 광고 클릭 시 연결될 웹페이지 URL
}


/// SwiftUI에서 SafariServices의 SFSafariViewController를 사용하기 위한 래퍼
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        return safariVC
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // 업데이트 시 특별히 할 일 없음
    }
}


struct AdBannerSection: View {
    /// 현재 표시될 랜덤 광고 데이터를 저장하는 @State 변수
    @State public var currentAd: AdData?
    /// SafariView를 모달로 띄울지 결정하는 @State 변수
    @State private var showingSafariView: Bool = false
 

    
    /// 인앱 광고 데이터 목록
    static let ads: [AdData] = [
        AdData(imageName: "adImg_01", targetURL: URL(string: "https://www.apple.com/kr/")!),
        AdData(imageName: "adImg_02", targetURL: URL(string: "https://www.google.com/")!),
        AdData(imageName: "adImg_03", targetURL: URL(string: "https://www.youtube.com/")!),
        AdData(imageName: "adImg_04", targetURL: URL(string: "https://www.naver.com/")!),
        AdData(imageName: "adImg_05", targetURL: URL(string: "https://www.daum.net/")!),
        AdData(imageName: "adImg_06", targetURL: URL(string: "https://www.apple.com/kr/")!),
        AdData(imageName: "adImg_07", targetURL: URL(string: "https://www.google.com/")!),
        AdData(imageName: "adImg_08", targetURL: URL(string: "https://www.youtube.com/")!),
        AdData(imageName: "adImg_09", targetURL: URL(string: "https://www.naver.com/")!),
        AdData(imageName: "adImg_10", targetURL: URL(string: "https://www.daum.net/")!),
    ]
    
    init() {
        _currentAd = State(initialValue: Self.ads.randomElement())
    }
    
    /// 외부에서 currentAd를 지정할 수 있도록 하는 생성자 (미리보기 등에서 사용)
    init(currentAd: AdData?) {
        self._currentAd = State(initialValue: currentAd)
    }
    
    
    var body: some View {
        
        // currentAd가 nil이 아닐 때만 광고 표시
        if let ad = currentAd {
            Button(action: {
                // 광고 클릭 시 SafariView 표시
//                showingSafariView = true
                print("광고클릭!")
            }) {
                Image(ad.imageName) // 광고 이미지 이름 사용
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 370) // 광고 이미지 크기 조절
                    .cornerRadius(10)
                
            }
//            .shadow(Color:.gray(OpacityTransition(0.5)),radius: 5)
            // SafariView를 모달로 띄움
//            .sheet(isPresented: $showingSafariView) {
//                SafariView(url: ad.targetURL)
//                    .ignoresSafeArea() // 웹뷰가 안전 영역을 무시하고 전체 화면을 차지하도록
//            }
//            .padding(.vertical) // 광고 주변에 여백 추가
        }
            
    }
}

#Preview {
    AdBannerSection(currentAd: AdBannerSection.ads[0])
    
}
