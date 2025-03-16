//
//  ActiveExcerciseCard.swift
//  gym-bro
//

//

import SwiftUI

struct ActiveExcerciseCard: View {
    
    @Binding var exercise: Exercise
    
    @State private var showingEditView = false
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 20) {
                
                Text(exercise.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                exercise.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Weight: \(exercise.weight) lbs")
                    Spacer()
                    Text("\(exercise.reps) reps")
                    Spacer()
                    Text("\(exercise.sets) sets")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .onTapGesture {
                    showingEditView.toggle()
                }
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        Text(exercise.description)
                        }
                    }
            }.padding()
                Spacer()
            }
        .sheet(isPresented: $showingEditView) {
            EditWorkoutView(exercise: $exercise)
        }
    }
}

struct EditWorkoutView: View {
    @Binding var exercise: Exercise
    
    var body: some View {
        Form {
            Section(header: Text("Weight")) {
                HStack {
                    
                    Picker("Feet", selection: $exercise.weight) {
                        ForEach(1..<351, id: \.self) {number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .frame(height:200)
                    .pickerStyle(.wheel)
                    
                    
                    Text("lbs")
                        
                        
                }
            }
            
            Section(header: Text("Reps")) {
                Stepper(value: $exercise.reps, in: 1...50) {
                    Text("\(exercise.reps) reps")
                }
            }
            
            Section(header: Text("Sets")) {
                Stepper(value: $exercise.sets, in: 1...10) {
                    Text("\(exercise.sets) sets")
                }
            }
        }
    }
}



#Preview {
    
    @State var ex = Exercise.default
    
    return (
        ActiveExcerciseCard(exercise: $ex)
    )
   
}
