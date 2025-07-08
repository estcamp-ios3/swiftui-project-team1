//
//  RadarChart.swift
//  PullItUp
//
//  Created by J on 7/8/25.
//

import Foundation
import SwiftUI


// https://github.com/TheAppWizard/RadarChart
// 방사형 차트
struct RadarChart: View {
    let data: [Double]
    let labels: [String]
    let maxValues: [Double]
    let shapeColor: Color
    let radius: CGFloat
    let labelPadding: CGFloat = 35

    var body: some View {
        let totalSize = (radius + labelPadding) * 2

        ZStack {
            RadarChartShape(
                data: data,
                maxValues: maxValues,
                frameSize: CGSize(width: radius * 2, height: radius * 2),
                shapeColor: shapeColor,
                center: CGPoint(x: totalSize / 2, y: totalSize / 2)
            )

            RadarChartLabels(
                labels: labels,
                frameSize: CGSize(width: radius * 2, height: radius * 2),
                labelOffset: labelPadding,
                center: CGPoint(x: totalSize / 2, y: totalSize / 2)
            )
        }
        .frame(width: totalSize, height: totalSize)
    }
}

struct RadarChartShape: View {
    let data: [Double]
    let maxValues: [Double]
    let frameSize: CGSize
    let shapeColor: Color
    let center: CGPoint

    var body: some View {
        ZStack {
            Path { path in
                let radius = min(frameSize.width, frameSize.height) / 2
                let angle = 2 * .pi / Double(data.count)

                for i in 0..<data.count {
                    let currentAngle = Double(i) * angle - .pi / 2
                    let x = center.x + CGFloat(radius * cos(currentAngle))
                    let y = center.y + CGFloat(radius * sin(currentAngle))

                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                path.closeSubpath()
            }
            .stroke(Color.primary.opacity(0.5), lineWidth: 2)
            
            ForEach(0..<data.count, id: \.self) { i in
                let radius = min(frameSize.width, frameSize.height) / 2
                let angle = 2 * .pi / Double(data.count)
                let currentAngle = Double(i) * angle - .pi / 2

                let x = center.x + CGFloat(radius * cos(currentAngle))
                let y = center.y + CGFloat(radius * sin(currentAngle))

                Path { path in
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                .stroke(Color.primary.opacity(0.3), lineWidth: 1)
            }

            ForEach(0..<data.count, id: \.self) { index in
                let radius = min(frameSize.width, frameSize.height) / 2
                let angle = 2 * .pi / Double(data.count)

                let currentAngle = Double(index) * angle - .pi / 2
                let currentRadius = (data[index] / maxValues[index]) * radius
                let x = center.x + CGFloat(currentRadius * cos(currentAngle))
                let y = center.y + CGFloat(currentRadius * sin(currentAngle))

                Circle()
                    .fill(shapeColor)
                    .frame(width: 10, height: 10)
                    .position(x: x, y: y)
            }

            Path { path in
                let radius = min(frameSize.width, frameSize.height) / 2
                let angle = 2 * .pi / Double(data.count)

                for i in 0..<data.count {
                    let currentAngle = Double(i) * angle - .pi / 2
                    let currentRadius = (data[i] / maxValues[i]) * radius
                    let x = center.x + CGFloat(currentRadius * cos(currentAngle))
                    let y = center.y + CGFloat(currentRadius * sin(currentAngle))

                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                path.closeSubpath()
            }
            .stroke(shapeColor.opacity(0.5), lineWidth: 1)
            .fill(shapeColor.opacity(0.3)) // It is only available in iOS 17.0 or newer
        }
    }
}


struct RadarChartLabels: View {
    let labels: [String]
    let frameSize: CGSize
    let labelOffset: CGFloat
    let center: CGPoint

    var body: some View {
        let radius = min(frameSize.width, frameSize.height) / 2
        let angle = 2 * .pi / Double(labels.count)

        ForEach(0..<labels.count, id: \.self) { index in
            let currentAngle = Double(index) * angle - .pi / 2
            let x = center.x + (radius + labelOffset) * CGFloat(cos(currentAngle))
            let y = center.y + (radius + labelOffset) * CGFloat(sin(currentAngle))

            Text(wrappedText(for: labels[index]))
                .foregroundColor(.black)
                .font(.callout)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 130)
                .position(x: x, y: y)
        }
    }

    func wrappedText(for text: String) -> String {
        let words = text.split(separator: " ")
        
        // 띄어쓰기가 있으면 앞뒤 나눠서 줄바꿈
        if words.count >= 2 {
            let firstLine = words.dropLast().joined(separator: " ")
            let secondLine = words.last ?? ""
            
            return "\(firstLine)\n\(secondLine)"
        }

        // 띄어쓰기가 없을 때: 6글자 이상이면 강제로 줄바꿈
        if text.count > 6 {
            let index = text.index(text.startIndex, offsetBy: text.count / 2)
            let first = text[..<index]
            let second = text[index...]
            
            return "\(first)\n\(second)"
        }
        
        // 기본 그대로 출력
        return text
    }
}
