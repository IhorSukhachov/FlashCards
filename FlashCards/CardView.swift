import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    @State private var offset: CGSize = .zero
    @State private var isShowingAnswer: Bool = false

    let card: Card
    let removal: (Bool) -> Void // Non-optional

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor
                    ? .white
                    : .white.opacity(1 - Double(abs(offset.width / CGFloat(50))))
                )
                .background(
                    accessibilityDifferentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25)
                        .fill(offset.width == 0
                              ? Color.clear
                              : offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)

            VStack {
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / CGFloat(5)))) // fixed type
        .offset(x: offset.width * CGFloat(5)) // fixed type
        .opacity(2 - Double(abs(offset.width / CGFloat(50)))) // fixed type
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    let threshold: CGFloat = 100
                    if abs(offset.width) > threshold {
                        let isCorrect = offset.width > 0
                        withAnimation {
                            removal(isCorrect)
                        }
                    }
                    offset = .zero // reset for next card
                }
        )
        .onTapGesture { isShowingAnswer.toggle() }
        .animation(.spring, value: offset)
    }
}

// Preview
#Preview {
    CardView(card: .example) { isCorrect in
        print("Answered:", isCorrect)
    }
}
