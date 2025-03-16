//
//  CurrentWorkout.swift
//  gym-bro
//
//

import Foundation

@Observable
class CurrentWorkout {
    
    // overal exercise control
    
    var exercises: [Exercise]
    var completedExercises: [Exercise]
    var currentExercise: Exercise? = nil
    
    var currentState: WorkoutState = WorkoutState.inactive
    var currentWorkoutDate: Date?
    
    enum WorkoutState: CaseIterable {
        case active
        case paused
        case inactive
    }
    
    private var timer: WorkoutTimer = WorkoutTimer()
    
    init(completedExercises: [Exercise] = [], currentExercise: Exercise? = nil) {
        self.completedExercises = completedExercises
        self.currentExercise = currentExercise
        self.exercises = []
        self.currentWorkoutDate = nil
    }
    
    
    func startWorkout() {
        timer.startTimer()
        self.currentState = WorkoutState.active
        self.currCardState = CardStates.swiping
        self.currentWorkoutDate = Date()
    }
    
    func cancelWorkout() {
        print("Spent \(timer.getTime()) seconds working out")
        if self.currentExercise != nil {
           finishedCurrentExercise()
        }
        self.currentWorkoutDate = nil
        self.currentExercise = nil
        self.currentState = WorkoutState.inactive
        resetCards()
        timer.cancelTimer()
        
        Task {
            await getExercises()
        }
    }
    func pauseResumeInitWorkout() {
        
        if self.currentState == WorkoutState.active {
            self.currentState = WorkoutState.paused
            timer.pauseTimer()
        }
        else if self.currentState == WorkoutState.paused {
            self.currentState = WorkoutState.active
            timer.startTimer()
        }
        else {
            startWorkout()
        }
    }
    
    func setCurrentExercise(newExercise: Exercise?) {
        self.currentExercise = newExercise
        if self.currentExercise != nil {
            self.currentExercise?.duration = timer.getTime()
        }
    }
    func skipExercise(skippedExercise: Exercise) {
        // do something with the skipped exercise i.e lower its score in db
        print("skipping \(skippedExercise)")
    }
    func finishedCurrentExercise() {
        // do something with exercise that was just finished
        if currentExercise == nil {
            print("no exercise in current")
            return
        }
        currentExercise?.duration = timer.getTime() - (currentExercise?.duration ?? 0)
        currentExercise?.workoutGroupDate = currentWorkoutDate ?? Date()
        print("just finished \(self.currentExercise!)")
        self.completedExercises.append(self.currentExercise!)
        addCompletedExercise(completedExercise: self.currentExercise!)
        setCurrentExercise(newExercise: nil)
    }
    
    func getExercises() async {
        print("getting exercises current size \(exercises.count)")
        
//        self.exercises.append(contentsOf: [Exercise.default, Exercise.default])
        
        do {
            let newRecommendations = try await getRecommendation()
//            print(newRecommendations)
            self.exercises = newRecommendations
        }
        catch {
            print("getting workouts error \(error)")
        }
        
        print("now length \(exercises.count)")
    }
    
    func getTimeString() -> String {
        if self.currentState == WorkoutState.active {
            return timer.getTimeString()
        }
        else if self.currentState == WorkoutState.inactive {
            return "Start"
        }
        else {
            return "paused"
        }
                
    }

    
    // card logic
    var currCardState = CardStates.start
    var currCardIndex = 0
    
    func cardTransition(direction: FourDirections) {
        
        switch currCardState {
        case .start:
            if direction == FourDirections.right {
                currCardState = CardStates.swiping
                startWorkout()
            }
        case .swiping:
            if direction == FourDirections.right && currentState == WorkoutState.active {
                currCardState = CardStates.active
                setCurrentExercise(newExercise: exercises[currCardIndex])
            }
            else if direction == FourDirections.top {
                currCardState = CardStates.moreInfo
            }
            else if direction == FourDirections.left && currentState == WorkoutState.active {
                skipExercise(skippedExercise: exercises[currCardIndex])
                nextCard()
            }
        case .active:
            if (direction == FourDirections.left || direction == FourDirections.right)  && currentState == WorkoutState.active {
                currCardState = CardStates.reviewing
            }
        case .reviewing:
            return
        case .moreInfo:
            if direction == FourDirections.bottom {
                currCardState = CardStates.swiping
            }
        case .end:
            if direction == FourDirections.left {
                currCardState = CardStates.start
                resetCards()
            }
        }
        
    }
    
    func finishedExerciseWithReview(review: Int) {
        if currentExercise != nil {
            currentExercise?.score = Float(review)
            finishedCurrentExercise()
            currCardState = CardStates.swiping
        }
        
        nextCard()
    }
    
    private func nextCard() {
        currCardIndex = exercises.index(after: currCardIndex)
        
        if (currCardIndex + 2 > exercises.endIndex) {
//            getExercises()
            print("almost out")
        }
        
        if (currCardIndex >= exercises.endIndex) {
            currCardState = CardStates.end
        }
    }
    
    private func resetCards() {
        currCardState = CardStates.start
        currCardIndex = 0
    }

    
}
