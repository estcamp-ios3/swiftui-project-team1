//
//  ContentView.swift
//  PullItUp
//
//  Created by J on 7/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // .modelContainer 주입 시, modelContext도 자동 생성됨
    // context를 통해 insert, delete 등등이 가능함
    @Environment(\.modelContext) private var context
    
    var body: some View {
        TabView {
            Tab("홈", systemImage: "house") {
                HomeView()
            }
            
            Tab("통계", systemImage: "chart.bar.xaxis") {
                Text("통계")
            }
            
            Tab("더보기", systemImage: "ellipsis") {
                NavigationStack{
                    Seemore()
                }
            }
            
            Tab("테스트", systemImage: "chart.bar.xaxis") {
                TestView()
            }
        }
        .task {
            // ContentView 열릴 때 딱 한번만 호출됨
            // 파일 체크(존재 유무)를 위해, @Environment를 통해 context를 받아서 파라미터로 전달
            DataLoader.loadJSONAndSave(modelContext: context)
        }
    }
}

#Preview {
    ContentView()
}
