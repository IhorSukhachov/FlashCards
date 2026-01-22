//
//  Card.swift
//  FlashCards
//
//  Created by Ihor Sukhachov on 22.01.2026.
//

import Foundation

struct Card {
    var prompt: String
    var answer: String
    
    static let example = Card(prompt: "The capital of GB", answer: "Not Paris ")
}
