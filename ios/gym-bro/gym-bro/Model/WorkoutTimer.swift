//
//  WorkoutTimer.swift
//  gym-bro
//
//

import Foundation

@Observable
class WorkoutTimer {
    private var timer: Timer?
    private var timerCount: Int = 0
    
    // timer functionality
    func startTimer() {

            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self else { return }

                
                timerCount += 1
                // Optionally update UI or trigger other actions here
            }
        }
    
    func cancelTimer() {
        self.timer?.invalidate()
        self.timerCount = 0
    }
    
    func pauseTimer() {
        timer?.invalidate()
    }
    
    func getTime() -> Int {
        return timerCount
    }
    
    func getTimeString() -> String {
        return formatTime(seconds: timerCount)
    }
    
    
    func formatTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
