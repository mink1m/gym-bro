//
//  gym_broApp.swift
//  gym-bro
//
//

import SwiftUI
import Firebase

@main
struct gym_broApp: App {
    
    @State private var modelData: ModelData = ModelData()
    
    init() {
        FirebaseApp.configure()
    }

    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
    }
}
