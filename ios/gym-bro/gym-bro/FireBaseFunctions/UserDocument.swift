//
//  UserDocument.swift
//  gym-bro
//
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

func getCurrentUserProfile() async -> Profile? {
    
    do {
        let db = Firestore.firestore()
        guard let email = Auth.auth().currentUser?.email else { return nil }
        let userRef = db.collection("users").document(email)
        
        let userDoc = try await userRef.getDocument()
        
        if userDoc.exists {
            let profile = try userDoc.data(as: Profile.self)
            
            return profile
        }
        
        return nil
        
    }
    catch {
        return nil
    }
}

func updateCurrentUserProfile(newProfile: Profile) async -> Bool{
    
    guard let curEmail = Auth.auth().currentUser?.email else {
        return false
    }
    
    let userRef = Firestore.firestore().collection("users").document(curEmail)
    let encoder = Firestore.Encoder()
    
    do {
        let userData = try encoder.encode(newProfile)
        try await userRef.updateData(userData)
        return true
    }
    catch {
        print("update user error \(error.localizedDescription)")
        return false
    }

}

func addCompletedExercise(completedExercise: Exercise) {
    guard let curEmail = Auth.auth().currentUser?.email else {
        return
    }
    
    let userRef = Firestore.firestore().collection("users").document(curEmail)
    do {
        try userRef.collection("workoutHistory").addDocument(from: completedExercise)
    }
    catch {
        print(error)
    }
}


