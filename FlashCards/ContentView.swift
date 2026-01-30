import SwiftUI
import Combine
import SwiftData

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled

    @Query(sort: \Card.prompt) var storedCards: [Card] // SwiftData query

    @State private var cards = [Card]() // local array for UI order
    @State private var showingEditSheet = false
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true

    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()

            VStack {
                Text("Time remaining \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)

                ZStack {
                    ForEach(cards) { card in
                        let index = cards.firstIndex(of: card) ?? 0

                        CardView(card: card) { isCorrect in
                            handleAnswer(for: card, correct: isCorrect)
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)

                if cards.isEmpty {
                    Button("Start again") {
                        loadData()
                        timeRemaining = 100
                        isActive = true
                    }
                    .padding()
                    .background(.white)
                    .foregroundStyle(.black)
                    .clipShape(.capsule)
                }
            }

            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingEditSheet = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()

            // Accessibility buttons
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            if let card = cards.last {
                                handleAnswer(for: card, correct: false)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }

                        Spacer()

                        Button {
                            if let card = cards.last {
                                handleAnswer(for: card, correct: true)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { _ in
            guard isActive else { return }
            if timeRemaining > 0 { timeRemaining -= 1 }
        }
        .onChange(of: scenePhase) { phase in
            isActive = (phase == .active && !cards.isEmpty)
        }
        .sheet(isPresented: $showingEditSheet, onDismiss: loadData) {
            EditCards()
        }
        .onAppear(perform: loadData)
    }

    // MARK: - Card logic

    func handleAnswer(for card: Card, correct: Bool) {
        guard let index = cards.firstIndex(of: card) else { return }

        if correct {
            // Remove correct card from SwiftData and local array
            modelContext.delete(card)
            cards.remove(at: index)
        } else {
            // Wrong → move to bottom visually
            let wrongCard = cards.remove(at: index)
            cards.append(wrongCard)
        }

        if cards.isEmpty { isActive = false }
    }

    func loadData() {
        // Load SwiftData cards into local array
        cards = storedCards
        timeRemaining = 100
        isActive = !cards.isEmpty
    }
}
