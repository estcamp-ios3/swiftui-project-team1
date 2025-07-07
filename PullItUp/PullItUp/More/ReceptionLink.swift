//
//  ReceptionLink.swift
//  PullItUp
//
//  Created by suji chae on 7/6/25.
//

import Foundation

struct ReceptionLink: Identifiable {
    var id: UUID = UUID()
    
    var title: String
    var description: String
    var link: String
    var image: String
    
}

let receptionLinks: [ReceptionLink] = [
        ReceptionLink(
            title: "KPC자격",
            description: "국가자격 · 한국수어교육능력검정시험. 한국수어교원 자격 2급 등 응시자격 확인 및 시험일정, 원서접수를 확인해보세요.",
            link: "https://license.kpc.or.kr/kpc/qualfAthrz/index.do;jsessionid=0DCA4FDF84BFE80C0591E70BA61076DB.WU01",
            image: "KPCTumb"),

        ReceptionLink(
            title: "Q-net",
            description: "국가기술자격: 기술사, 기능장, 기사, 산업기사, 서비스(일부족목) 등 응시자격 확인 및 시험일정, 원서접수를 확인해보세요.",
            link: "https://www.q-net.or.kr/man001.do?gSite=Q&gIntro=Y",
            image: "QNetTumb"),
    
    
]
