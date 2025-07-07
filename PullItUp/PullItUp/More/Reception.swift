//
//  Reception.swift
//  PullItUp
//
//  Created by suji chae on 7/6/25.
//

import SwiftUI

struct Reception: View {
    var body: some View {
        NavigationView{
            List(receptionLinks) {item in
                Link(destination: URL(string: item.link)!){
                    HStack(alignment: .top, spacing: 12){
                        Image(item.image)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading, spacing: 5){
                            Text(item.title)
                                .font(.headline)
                            Text(item.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("원서접수안내")
        }
    }
}
#Preview {
    Reception( )
}
