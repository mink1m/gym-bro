//
//  Profile.swift
//  gym-bro
//

//

import Foundation

struct Profile: Hashable, Codable {
    

    var first: String
    var last: String
    var dateOfBirth: Date
    var weight: Int
    var height: Height
    var sex: Sexes
    // yada yada
    
    init(first: String, last: String, dateOfBirth: Date, weight: Int, height: Height, sex: Sexes) {
        self.first = first
        self.last = last
        self.dateOfBirth = dateOfBirth
        self.weight = weight
        self.height = height
        self.sex = sex
        
    }
    
    static let `default` = Profile(first: "", last: "", dateOfBirth: Date(), weight: 150, height: Height(feet: 5, inches: 10), sex: Sexes.male)
    
    struct Height: Hashable, Codable {
        var feet: Int
        var inches: Int
    }
    
    enum Sexes: String, Hashable, Codable, CaseIterable, Identifiable {
        case female = "female"
        case male = "male"
        
        var id: String { rawValue }
    }
    
    enum CodingKeys: String, CodingKey {
        case first
        case last
        case dateOfBirth
        case weight
        case height
        case sex
      }

}
