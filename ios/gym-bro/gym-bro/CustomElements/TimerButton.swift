//
//  TimerButton.swift
//  gym-bro
//

//

import SwiftUI

struct TimerButton: View {

        
    var getTimeString: () -> String
    var onTap: () -> Void
    var onLongHold: () -> Void
    
    private let holdTime: Double = 3.0
    private let timerInterval: Double = 1
    
    @GestureState private var holdingButton = false
    @State private var progress: Double = 0
    @State private var holdTimerCount: Double = 0
    @State private var timerHoldSuccess: Bool = false
        
    
    var body: some View {
        
        TimerButtonBase(buttonText: "\(getTimeString())", progress: progress, clickAction: {
            
            if timerHoldSuccess == false {
                print("clicked")
                onTap()
            }
            else {
                timerHoldSuccess = false
            }
            
        })
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
                        if holdingButton {
                            withAnimation {
                                holdTimerCount += timerInterval
                                progress = Double(holdTimerCount) / holdTime // Adjust this based on your needs
                            }
                        }
                        else {
                            withAnimation {
                                holdTimerCount = 0
                                progress = 0
                            }


                        }
                    }
            }
            .simultaneousGesture(
                    LongPressGesture(minimumDuration: holdTime)
                        .updating($holdingButton) { value, state, transaction in
                            state = value
                            print("holding")
                        }
                        .onEnded { _ in
                            // Your action here when button is held for the required duration
                            timerHoldSuccess = true
                            print("done")
                            onLongHold()
                        }
                )
    }
}

#Preview {
    TimerButton(getTimeString: {"test"}, onTap: {}, onLongHold: {})
}
