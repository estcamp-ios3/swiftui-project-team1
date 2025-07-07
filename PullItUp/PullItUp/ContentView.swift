//
//  ContentView.swift
//  PullItUp
//
//  Created by J on 7/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        // 이 주석은 지우셔도 됩니다.
        // 탭 개발 맡으신 분들은,
        TabView {
            Tab("홈", systemImage: "house") {
                HomeView()
            }
            
            Tab("통계", systemImage: "square.and.pencil") {
                Text("통계")
            }
            
            Tab("더보기", systemImage: "square.and.pencil") {
                NavigationStack{
                    Seemore()
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
