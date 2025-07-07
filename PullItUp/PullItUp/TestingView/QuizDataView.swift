import SwiftUI

struct QuizDataView: View {
    @State private var selectAnswer: Int? = nil
    
    let answer = ["답", "오답1", "오답2", "오답3의 내용이 정말정말 길어져서 두번째 줄까지 온다면 어떻게 되나요"]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("문제 본문\n이렇게 줄이 몇개 있어도\n인식을 잘 해줄까")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                
                VStack(spacing: 12) {
                    ForEach(0..<answer.count, id: \.self) { index in
                        Button(action: {
                            selectAnswer = index
                        }) {
                            HStack {
                                Text("\(index + 1). \(answer[index])")
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Image(systemName: selectAnswer == index ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor(selectAnswer == index ? .blue : .gray)
                                
                                Spacer()
                            }
                            .padding(13)
                            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 16)
                    }
                }

                Spacer()
            }
            .navigationTitle(Text("Q1"))
        }
    }
}

#Preview {
    QuizDataView()
}
