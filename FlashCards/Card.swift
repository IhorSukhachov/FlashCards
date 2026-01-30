//
//  Card.swift
//  FlashCards
//
//  Created by Ihor Sukhachov on 22.01.2026.
//
import SwiftData
import Foundation

@Model
class Card: Identifiable  {
    var id = UUID()
    var prompt: String
    var answer: String
    
    init(prompt: String, answer: String) {
        self.id = UUID()
        self.prompt = prompt
        self.answer = answer
    }
    
    static let example = Card(prompt: "The capital of GB", answer: "Not Paris ")
}
