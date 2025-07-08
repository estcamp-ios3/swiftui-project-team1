//
//  ContentView.swift
//  PullItUp
//
//  Created by J on 7/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
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
            DataLoader.loadJSONAndSave(modelContext: context)
        }
    }
}

#Preview {
    ContentView()
}
