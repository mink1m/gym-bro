//
//  BaseCard.swift
//  gym-bro
//

//

import SwiftUI

struct BaseCard: View {
    var body: some View {
        Card {
            Text("Lets Go Gym Bro")
                .font(.largeTitle)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    BaseCard()
}
