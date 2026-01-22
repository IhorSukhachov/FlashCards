//
//  CardView.swift
//  FlashCards
//
//  Created by Ihor Sukhachov on 22.01.2026.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                Text(card.answer)
                    .font(.title)
                    .foregroundStyle(.secondary)
            }
            .padding(20)
            .multilineTextAlignment(TextAlignment.center)
                
        }
        .frame(width: 450, height: 250)
    }
}

#Preview {
    CardView(card: .example)
}
