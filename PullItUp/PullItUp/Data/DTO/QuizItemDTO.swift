//
//  QuizItemDTO.swift
//  PullItUp
//
//  Created by J on 7/8/25.
//

import Foundation

// DTO : Data Transfer Object
// 데이터를 전송하기 위해 필요한 객첵로, 비즈니스 로직 X
// 쉽게 말하면 JSON Decoding용 구조체

struct QuizItemDTO: Decodable {
    let licenseName: String     // 자격증 이름
    let number: Int             // 문제 번호
    let question: String        // 질문
    let options: [String]       // 선택지 (1~4)
    let answer: String          // 답
    let explanation: String     // 해설
    let subject: String         // 과목 분류
    let imageName: String       // 문제 본문에 들어갈 이미지 이름
}

