//
//  Info.swift
//  PullItUp
//
//  Created by J on 7/8/25.
//


//{
//    @Model은 SwiftData가 저장하고 관리할 수 있는 클래스를 정의한다.
//    이 클래스는 자동으로 저장소에서 불러오고 수정할 수 있게 된다.

//    Ex)

//    @Model
//    class QuizItem {
//        var number: Int
//        var question: String
//       ...
//    }
//}



//{
//    @Query는 SwiftData의 모델 데이터를 뷰에서 자동으로 로딩하고 업데이트되도록 연결한다.
//    내부적으로는 FetchDescriptor를 생성해 사용한다

//    Ex)
    
//    @Query var quizzes: [QuizItem]
//}



//{
//    SwiftData는 내부적으로 ModelContainer라는 DB 컨테이너를 사용한다.
//    여기에 어떤 모델들을 저장할지 선언해야 한다.
//    앱 시작 시 .modelContainer(for:)로 등록한다.
//    
//    Ex)
//    .modelContainer(for: [QuizItem.self, ImportedFile.self])
//}
