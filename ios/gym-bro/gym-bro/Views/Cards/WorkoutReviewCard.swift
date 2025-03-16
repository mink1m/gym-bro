//
//  WorkoutReviewCard.swift
//  gym-bro
//

//

import SwiftUI

struct WorkoutReviewCard: View {
    var body: some View {
        Card {
            VStack(alignment: .leading) {
                Text("Dumbell Shoulder Press")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                
                Text("Exercises Completed")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 15)
                
                Text("1. Blah blah info")
                Text("2. Blah blah more info")
                
                Text("Time Spent")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 15)
                Text("1 hour")
                Spacer()
            }
        }
    }
}

#Preview {
    WorkoutReviewCard()
}
