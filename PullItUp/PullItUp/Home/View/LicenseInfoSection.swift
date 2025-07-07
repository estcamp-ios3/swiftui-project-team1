//
//  LicenseInfoSection.swift
//  PullItUp
//
//  Created by catharina J on 7/7/25.
//

import SwiftUI

struct LicenseInfoSection: View {
    @State private var isReceptionShow: Bool = false
    
    var body: some View {
        
        VStack(spacing: 8) {
            Text("원서접수 방법도 확인해 보세요!")
                .font(.title2)
                .fontWeight(.bold)
            Button(action: {isReceptionShow = true}){
                HStack(spacing: 10){
                    Image("QNetTumb")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                    Image("KPCTumb")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
            
            
        }
        .sheet(isPresented: $isReceptionShow) {
            Reception()
        }
        
    }
}

#Preview {
    LicenseInfoSection()
}
