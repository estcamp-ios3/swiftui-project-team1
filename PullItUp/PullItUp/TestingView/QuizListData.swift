//
//  QuizListData.swift
//  PullItUp
//
//  Created by 이지훈 on 7/7/25.
//

import Foundation

struct QuizList: Identifiable {
    var id: UUID = UUID()
    var qNumber: String
    var qText: String
    var qAnswer1: String
    var qAnswer2: String
    var qAnswer3: String
    var qAnswer4: String
    var qHint: String
    var qTrueAnswer: String
}

var quizLists: [QuizList] = [
    QuizList(qNumber: "Q1", qText: "1번 문제 본문", qAnswer1: "A", qAnswer2: "B", qAnswer3: "C", qAnswer4: "D", qHint: "1번 문제 힌트", qTrueAnswer: "1번 문제 정답"),
    QuizList(qNumber: "Q2", qText: "2번 문제 본문", qAnswer1: "ㄱ", qAnswer2: "ㄴ", qAnswer3: "ㄷ", qAnswer4: "ㄹ", qHint: "2번 문제 힌트", qTrueAnswer: "2번 문제 정답"),
    QuizList(qNumber: "Q3", qText: "3번 문제 본문", qAnswer1: "가", qAnswer2: "나", qAnswer3: "다", qAnswer4: "라", qHint: "3번 문제 힌트", qTrueAnswer: "3번 문제 정답"),
    QuizList(qNumber: "Q4", qText: "4번 문제 본문", qAnswer1: "a", qAnswer2: "b", qAnswer3: "c", qAnswer4: "d", qHint: "4번 문제 힌트", qTrueAnswer: "4번 문제 정답"),
    QuizList(qNumber: "Q5", qText: "5번 문제 본문", qAnswer1: "1", qAnswer2: "2", qAnswer3: "3", qAnswer4: "4", qHint: "5번 문제 힌트", qTrueAnswer: "5번 문제 정답"),
    QuizList(qNumber: "Q6", qText: "6번 문제 본문", qAnswer1: "가가", qAnswer2: "나나", qAnswer3: "다다", qAnswer4: "라라", qHint: "6번 문제 힌트", qTrueAnswer: "6번 문제 정답"),
    QuizList(qNumber: "Q7", qText: "7번 문제 본문", qAnswer1: "123", qAnswer2: "456", qAnswer3: "789", qAnswer4: "0", qHint: "7번 문제 힌트", qTrueAnswer: "7번 문제 정답"),
    QuizList(qNumber: "Q8", qText: "8번 문제 본문", qAnswer1: "1번답", qAnswer2: "2번답", qAnswer3: "3번답", qAnswer4: "4번답", qHint: "8번 문제 힌트", qTrueAnswer: "8번 문제 정답"),
    QuizList(qNumber: "Q9", qText: "9번 문제 본문", qAnswer1: "답이고", qAnswer2: "오답이고", qAnswer3: "오답이고", qAnswer4: "오답이다", qHint: "9번 문제 힌트", qTrueAnswer: "9번 문제 정답"),
    QuizList(qNumber: "Q10", qText: "10번 문제 본문", qAnswer1: "오답인데", qAnswer2: "정답이고", qAnswer3: "오답인데", qAnswer4: "오답이네", qHint: "10번 문제 힌트", qTrueAnswer: "10번 문제 정답"),
]
