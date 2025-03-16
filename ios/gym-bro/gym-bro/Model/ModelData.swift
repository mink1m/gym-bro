//
//  ModelData.swift
//  gym-bro
//

//

import Foundation

@Observable
class ModelData {
    // Class to keep track of all data in app that needs to be passed down
    // from root view
    
    // Authentication
    var authModel = AuthenticationModel()
    
    // User Info
    var profile = Profile.default
    
    // Workout Data
    var currentWorkout = CurrentWorkout()
    
    // User Stats
}
