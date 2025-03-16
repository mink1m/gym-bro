//
//  WorkoutView.swift
//  gym-bro
//
 
//

import SwiftUI

struct WorkoutView: View {
    
    @Environment(ModelData.self) private var modelData
    
    @State private var timerCount: Double = 0
    @GestureState private var holdingButton = false
    @State private var progress: Double = 0
    @State private var holdTimerCount: Double = 0
    
    
    
    var body: some View {
        
        @Bindable var modelData = modelData
        
        ZStack {
            VStack {
                Image("gym-bro-logo")
                    .resizable()
                    .frame(width: 50, height: 50)
                BaseCardStateController(
                    data: $modelData.currentWorkout.exercises,
                    currIndex: modelData.currentWorkout.currCardIndex,
                    currState: modelData.currentWorkout.currCardState,
                    cardTransition: modelData.currentWorkout.cardTransition
                )
                TimerButton(getTimeString: modelData.currentWorkout.getTimeString , onTap: modelData.currentWorkout.pauseResumeInitWorkout, onLongHold: modelData.currentWorkout.cancelWorkout)
            }
            
            if modelData.currentWorkout.currCardState == CardStates.reviewing {
                RatingView(onSubmit: modelData.currentWorkout.finishedExerciseWithReview)
            }
        }
    }
}

#Preview {
    WorkoutView()
        .environment(ModelData())
}
