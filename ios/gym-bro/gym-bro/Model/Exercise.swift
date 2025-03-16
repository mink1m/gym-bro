//
//  Exercise.swift
//  gym-bro
//
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct BaseParams: Hashable, Codable {
    var bodyWeightRatio: BodyWeightRatio
}
struct BodyWeightRatio: Hashable, Codable {
    var female: Float
    var male: Float
}

struct Exercise: Hashable, Codable, Identifiable {
    
    var id: UUID = UUID()
    
    var name: String
    var type: String
    var description: String
    var imageName: String?
    var muscleGroups: [String]
    var baseParams: BaseParams
    
    
    var date: Date
    var weight: Int
    var reps: Int
    var sets: Int
    var duration: Int
    var score: Float
    var exercise: DocumentReference?
    var workoutGroupDate: Date
    
    static let `default` = Exercise(name: "Lat pull down", type: "machine", description: "You do a bit of this and then a bit of that and wam bam", imageName: "latpulldown", muscleGroups: ["Lats"], baseParams: BaseParams(bodyWeightRatio: BodyWeightRatio(female: 0.4, male: 0.45)), date: Date(), weight: 50, reps: 10, sets: 3, duration: 300, score: 4.0, exercise: nil, workoutGroupDate: Date())
    
    
    var image: Image {
        Image(imageName ?? "gym-bro-logo")
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case type
        case description
        case imageName = "image"
        case muscleGroups
        case baseParams
        case date
        case weight
        case reps
        case sets
        case duration
        case score
        case exercise
        case workoutGroupDate
    }
    
   
}



struct ExerciseRecommendationBuilder: Codable {
    
    
    @DocumentID var id: DocumentReference?
    var name: String
    var type: String
    var description: String
    var imageName: String?
    var muscleGroups: [String]
    var baseParams: BaseParams
    
    var dates: [Date] = []
    var weights: [Int] = []
    var sets: [Int] = []
    var reps: [Int] = []
    var scores: [Float] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case description
        case imageName = "image"
        case muscleGroups
        case baseParams
    }
}
