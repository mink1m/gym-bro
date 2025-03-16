//
//  WorkoutPreviewCard.swift
//  gym-bro
//

//

import SwiftUI

struct WorkoutPreviewCard: View {
    
    var exercise: Exercise
    
    var body: some View {
        Card {
            VStack(alignment: .leading) {
                exercise.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                    .padding(.top, 30)
                Spacer()
                Text(exercise.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                Text(exercise.muscleGroups.joined(separator: ", "))
                Spacer()
            }
        }
    }
}

#Preview {
    WorkoutPreviewCard(exercise: Exercise.default)
}
