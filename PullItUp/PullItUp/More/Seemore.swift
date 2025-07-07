//
//  Seemore.swift
//  PullItUp
//
//  Created by suji chae on 7/6/25.
//

import SwiftUI

struct Seemore: View {
    var body: some View {
        List{
            NavigationLink(destination: Reception()) {
                HStack {
                    Text("원서접수안내")
                }
                .font(.headline)
                .padding(.vertical, 8)
            }
        }
        .listStyle(.plain)
        .navigationTitle(Text("더보기"))
        .navigationBarTitleDisplayMode(.automatic)
        
    }
}

#Preview {
    NavigationStack {
        Seemore()
    }
}
