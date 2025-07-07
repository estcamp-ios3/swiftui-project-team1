//
//  HistoryView.swift
//  PullItUp
//
//  Created by suji chae on 7/7/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @guery private var sessions:[QuerySession]
    
    var body: some View {
        NavigationView{
            List(sessions) { session in
                VStack(alignmenet: .leading, spacing: 5){
                    Text("세션시작:\(session.startedAt.formatted())")
                    Text("\(session.id)")
                    Text("\(session.startedAt)")
                }
            }

        }
    }
}

#Preview {
    HistoryView()
}
