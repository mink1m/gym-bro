//
//  ContentView.swift
//  gym-bro
//
//

import SwiftUI

struct ContentView: View {
    @Environment(ModelData.self) private var modelData
    var body: some View {
        
        if (modelData.authModel.currAuthState == AuthenticationStates.signedIn) {
            HomeView()
        }
        else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
