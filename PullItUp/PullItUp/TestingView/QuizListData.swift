//
//  QuizListData.swift
//  PullItUp
//
//  Created by 이지훈 on 7/7/25.
//

import Foundation

struct Quiz: Identifiable, Codable {
    var id: Int { number }
    let number: Int
    let question: String
    let options: [String]
    let answer: String
    let explanation: String
    let subject: String
}

func loadQuizListData(filename: String = "jcg_210814") -> [Quiz] {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
        print("❗️JSON 파일을 찾을 수 없습니다.")
        return []
    }
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let quizList = try decoder.decode([Quiz].self, from: data)
        return quizList
    } catch {
        print("❗️Quiz 데이터 파싱 실패: \(error)")
        return []
    }
}

let quizListData: [Quiz] = loadQuizListData()
