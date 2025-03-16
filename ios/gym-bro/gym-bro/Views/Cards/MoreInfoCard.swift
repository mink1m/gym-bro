//
//  MoreInfoCard.swift
//  gym-bro
//
//

import SwiftUI

struct MoreInfoCard: View {
    
    var exercise: Exercise
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("More Info")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                exercise.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 100)
                
                Text(exercise.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                HStack {
                    Text("Weight: \(exercise.weight) lbs")
                    Spacer()
                    Text("\(exercise.reps) reps")
                    Spacer()
                    Text("\(exercise.sets) sets")
                }
                .font(.title3)
                .fontWeight(.semibold)
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        Text(exercise.description)
                        }
                    }
            }.padding()
                Spacer()
            }
    }
}

#Preview {
    MoreInfoCard(exercise: Exercise.default)
}
