//
//  EditCards.swift
//  FlashCards
//
//  Created by Ihor Sukhachov on 29.01.2026.
//

import SwiftUI
import SwiftData

struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Card.prompt) var cards: [Card]
    
    @State private var newPrompt: String = ""
    @State private var newAnswer: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    
                    TextField("Answer", text: $newAnswer)
                    
                    Button("Add Card", action: addCard)
                }
                
                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(Font.headline)
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit cards")
            .toolbar {
                Button("Done", action: done)
            }
        }
    }
    func done() {
        dismiss()
    }
    
//    func loadData() {
//        if let data = UserDefaults.standard.data(forKey: "Cards") {
//            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
//                cards = decoded
//            }
//        }
//    }
//    func saveData() {
//        if let data = try? JSONEncoder().encode(cards) {
//            UserDefaults.standard.set(data, forKey: "Cards")
//        }
//    }
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else {
            return
        }
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        modelContext.insert(card)
        newPrompt = ""
        newAnswer = ""
    }
    
    func removeCards(at offsets: IndexSet) {
        offsets.map { cards[$0] }.forEach { modelContext.delete($0) }
    }
}

#Preview {
    EditCards()
}
