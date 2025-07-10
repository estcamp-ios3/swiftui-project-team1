//
//  AdBanner.swift
//  PullItUp
//
//  Created by catharina J on 7/7/25.
//

import SwiftUI
import Foundation
import Observation

/// 개별 광고의 이미지 이름과 연결될 URL을 정의하는 구조체
struct AdData: Identifiable {
    let id = UUID() // 각 광고를 고유하게 식별하기 위한 ID
    let imageName: String // 앱 내 Assets.xcassets에 있는 이미지 이름
    let targetURL: URL // 광고 클릭 시 연결될 웹페이지 URL
}

// AdBannerViewModel: 광고 로직 및 데이터 관리
@Observable
class AdBannerViewModel {
    var currentAd: AdData?
    var showingSafariView: Bool = false
    
    private var timer: Timer?  // Timer 인스턴스 저장
    
    /// 인앱 광고 데이터 목록
    private static let ads: [AdData] = [
        AdData(imageName: "adImg_01", targetURL: URL(string: "https://www.shinhancard.com/pconts/html/benefit/event/1234541_2239.html")!),
        AdData(imageName: "adImg_02", targetURL: URL(string: "https://www.shinhancard.com/pconts/html/benefit/event/1233316_2239.html")!),
        AdData(imageName: "adImg_03", targetURL: URL(string: "https://www.shinhancard.com/pconts/html/benefit/event/1232114_2239.html")!),
        AdData(imageName: "adImg_04", targetURL: URL(string: "https://www.shinhancard.com/pconts/html/benefit/event/1224333_2239.html")!),
        AdData(imageName: "adImg_05", targetURL: URL(string: "https://www.shinhancard.com/pconts/html/benefit/event/1233640_2239.html")!),
        AdData(imageName: "adImg_06", targetURL: URL(string: "https://www.shinhancard.com/pconts/html/benefit/event/1234503_2239.html")!),
        AdData(imageName: "adImg_07", targetURL: URL(string: "https://www.shinhancard.com/pconts/html/benefit/event/1234487_2239.html")!),
        AdData(imageName: "adImg_08", targetURL: URL(string: "https://www.shinhancard.com/pconts/html/benefit/event/1234509_2239.html")!),
        AdData(imageName: "adImg_09", targetURL: URL(string: "https://www.shinhancard.com/pconts/html/benefit/event/1234505_2239.html")!),
        AdData(imageName: "adImg_10", targetURL: URL(string: "https://www.shinhancard.com/pconts/html/benefit/event/1233239_2239.html")!),
    ]
    
    init() {
        loadRandomAd() // 초기화 시 랜덤 광고 로드
        adRefreshTimer() // 타이머 설정
    }
    
    deinit{
        timer?.invalidate() // 타이머 무효화
    }
    
    // 30초마다 광고를 갱신하는 타이머 설정- 5초로 변경: 프로토타입 시연
    private func adRefreshTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.loadRandomAd()
        }
    }
    
    // 랜덤 광고를 currentAd에 설정하는 메서드
    func loadRandomAd() {
        self.currentAd = AdBannerViewModel.ads.randomElement()
    }
    
    // 광고 클릭 시 호출될 메서드
    func adTapped() {
        showingSafariView = true
    }
    
    // SafariView가 닫힐 때 광고 갱신
    func safariViewDismissed() {
         loadRandomAd()
    }
}


