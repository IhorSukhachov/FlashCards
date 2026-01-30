//
//  FlashCardsApp.swift
//  FlashCards
//
//  Created by Ihor Sukhachov on 22.01.2026.
//

import SwiftUI
import SwiftData

@main
struct FlashCardsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Card.self)
    }
}
