//
//  BuildRecommendations.swift
//  gym-bro
//
//

import Foundation
import Firebase

enum RecommendationError: Error {
    case setupError
}


func calculateScore(scoreList: [Float], dateList: [Date]) -> Float {
    if scoreList.isEmpty {
        return 0
    }
    
    // approach 1: exponential moving average
    let listCount = scoreList.count
    let multiplier = 2.0 / Float(listCount + 1)
    var score: Float = scoreList.last!
    
    for i in (0..<listCount).reversed() {
        score = score * multiplier + scoreList[i] * (1 - multiplier)
    }
    
    // If it has been a while since the user last did this workout, give a random probability of resetting the score
    let now = Date()
    let daysSince = Calendar.current.dateComponents([.day], from: dateList.first!, to: now).day!
    
    if daysSince > 14 {
        if Float.random(in: 0...1) > 0.5 {
            score = 0
        }
    }
    
    return score
}

func calculateSetsRepsWeight(
    setsList: [Int],
    repsList: [Int],
    weightList: [Int],
    dateList: [Date],
    baseWeight: Int,
    minWorkouts: Int = 3,
    baseSets: Int = 3,
    baseReps: Int = 10
) -> (sets: Int, reps: Int, weight: Int) {
    // Calculate the sets, reps, and weight that should be recommended to the user based on history

    // If there are no workouts, return the default
    if dateList.isEmpty {
        return (baseSets, baseReps, baseWeight)
    }

    // If there are less than the minimum number of workouts, return the most recent workout
    if dateList.count < minWorkouts {
        return (setsList[0], repsList[0], weightList[0])
    }

    // There are enough workouts to make a recommendation
    let daysSinceLastWorkout = Calendar.current.dateComponents([.day], from: dateList[0], to: Date()).day ?? 0

    // If the user has not worked out in a while, return an easier workout
    if daysSinceLastWorkout > 28 {
        return (baseSets, baseReps, Int(Float(weightList[0]) * 0.9))
    }

    // If the user had a change within the last 2 workouts, return the most recent workout
    if setsList[0] != setsList[1] || repsList[0] != repsList[1] || weightList[0] != weightList[1] {
        return (setsList[0], repsList[0], weightList[0])
    }

    // Now time for the actual recommendation
    // We will use a progressive overload approach to recommend the next workout

    // First, we will increase the reps
    if repsList[0] < 14 {
        return (setsList[0], repsList[0] + 2, weightList[0])
    }

    // Then, we will increase the weight if the reps are at the max
    let weightIncrease = 0.075 * Float(weightList[0]) // 7.5% increase
    return (setsList[0], baseReps, Int(Float(weightList[0]) + weightIncrease))
}

func getTargetMuscles(previousWorkoutMuscles: [String]) -> [String]{
//    var all_muscles = ["Forearms", "Lower Back", "Quads", "Tricep", "Biceps", "Hamstrings", "Chest", "Glutes", "Calf", "Mid back", "Shoulder", "Triceps", "Upper Back", "Mid Back", "Upper back", "Core", "Bicep"]
    
    let workoutCycle: [[String]] = [
        ["Chest", "Tricep", "Triceps", "Shoulder", "Core", "Forearms"],
        ["Lower Back", "Biceps", "Mid back", "Upper Back", "Upper back", "Mid Back", "Bicep"],
        ["Quads", "Hamstrings", "Glutes", "Calf"]
    ]
    
    if (previousWorkoutMuscles.isEmpty == true) {
        return workoutCycle[0]
    }
    
    var bestMatchIndex = 0
    var maxOverlapCount = 0
    
    for (index, cycle) in workoutCycle.enumerated() {
        let overlapCount = Set(previousWorkoutMuscles).intersection(Set(cycle)).count
        if overlapCount > maxOverlapCount {
            maxOverlapCount = overlapCount
            bestMatchIndex = index
        }
    }
    
    let nextIndex = (bestMatchIndex + 1) % workoutCycle.count
    
    return workoutCycle[nextIndex]
    
}

func getPreviousWorkoutMuscles(userRef: DocumentReference) async -> [String] {
    
    let userWorkoutHist = userRef.collection("workoutHistory").order(by: "workoutGroupDate", descending: true).limit(to: 10)
    
    var musclesWorked: [String] = []
    
    var recentGroupDate: Date? = nil
    
    do {
        let histDocuments = try await userWorkoutHist.getDocuments()
        
        histDocuments.documents.forEach({ (documentSnapshot) in
            do {
                let histExercise = try documentSnapshot.data(as: Exercise.self)
                if recentGroupDate == nil {
                    recentGroupDate = histExercise.workoutGroupDate
                }
                if recentGroupDate == histExercise.workoutGroupDate {
                    musclesWorked.append(contentsOf: histExercise.muscleGroups)
                }
            }
            catch {
                print("Hist muscles error: \(error)")
            }
        })
    }
    catch {
        print("get previous muscles error \(error)")
    }
    
    return musclesWorked
}

func getRecommendation() async throws -> [Exercise] {
    
    let db = Firestore.firestore()
    guard let email = Auth.auth().currentUser?.email else { throw(RecommendationError.setupError) }
    
    let userRef = db.collection("users").document(email)
    let userWorkoutHistoryQuery = userRef.collection("workoutHistory").order(by: "date", descending: true)
    
    let prevMusclesWorked = await getPreviousWorkoutMuscles(userRef: userRef)
    let targetMuscles: [String] = getTargetMuscles(previousWorkoutMuscles: prevMusclesWorked)
    print("previous", prevMusclesWorked)
    print("next", targetMuscles)
    
    let allExercisesQuery = db.collection("exercises").whereField("muscleGroups", arrayContainsAny: targetMuscles)

    var exerciseDict: [String: ExerciseRecommendationBuilder] = [:]

    // Fetch the user document
    let userProfile = try await userRef.getDocument(as: Profile.self)


    // Fetch all exercises that target the muscle groups specified
    
    let exerciseDocuments = try await allExercisesQuery.getDocuments()
    
    exerciseDocuments.documents.forEach({ (documentSnapshot) in
        do {
            let exercise = try documentSnapshot.data(as: ExerciseRecommendationBuilder.self)
            exerciseDict[documentSnapshot.documentID] = exercise
        }
        catch {
            print("All exercise error: \(error)")
        }
    })
    
    // Fetch the user's workout history
    let userWorkoutHistoryDocuments = try await userWorkoutHistoryQuery.getDocuments()
    
    for document in userWorkoutHistoryDocuments.documents {
        
        do {
            let exercise = try document.data(as: Exercise.self)
            
            if exerciseDict[exercise.exercise!.documentID] != nil {
                exerciseDict[exercise.exercise!.documentID]?.scores.append(exercise.score)
                exerciseDict[exercise.exercise!.documentID]?.sets.append(exercise.sets)
                exerciseDict[exercise.exercise!.documentID]?.reps.append(exercise.reps)
                exerciseDict[exercise.exercise!.documentID]?.weights.append(exercise.weight)
                exerciseDict[exercise.exercise!.documentID]?.dates.append(exercise.date)
            }
        }
        catch {
            print("User history error: \(error)")
        }
        
        
    }
    
    // Score the exercises based on the history
    var exercisesScored: [Exercise] = []
    
    for (_, exerciseData) in exerciseDict {
        let score = calculateScore(scoreList: exerciseData.scores, dateList: exerciseData.dates)
        var bwRatio: Float = exerciseData.baseParams.bodyWeightRatio.male
        
        if userProfile.sex == Profile.Sexes.female {
            bwRatio = exerciseData.baseParams.bodyWeightRatio.female
        }
        
        let (recommendedSets, recommendedReps, recommendedWeight) = calculateSetsRepsWeight(
            setsList: exerciseData.sets,
            repsList: exerciseData.reps,
            weightList: exerciseData.weights,
            dateList: exerciseData.dates,
            baseWeight: Int(Float(userProfile.weight) * bwRatio)
        )
        
        exercisesScored.append(Exercise(name: exerciseData.name, type: exerciseData.type, description: exerciseData.description, imageName: exerciseData.imageName, muscleGroups: exerciseData.muscleGroups, baseParams: exerciseData.baseParams, date: Date(), weight: recommendedWeight, reps: recommendedReps, sets: recommendedSets, duration: 0, score: score, exercise: exerciseData.id, workoutGroupDate: Date()))
    }
    
    let sortedExercises = exercisesScored.sorted {
        if $0.score == 0 { return $1.score < 6 }
        if $1.score == 0 { return $0.score > 6 }
        return $0.score > $1.score
    }
    // Return the sorted exercises
//    print(sortedExercises)
        
    return sortedExercises
}

