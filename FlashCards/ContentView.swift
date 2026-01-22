//
//  ContentView.swift
//  FlashCards
//
//  Created by Ihor Sukhachov on 22.01.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var cards = Array<Card>(repeating: .example, count: 10)
    var body: some View {
        CardView(card: .example)
    }
}
#Preview {
    ContentView()
}
