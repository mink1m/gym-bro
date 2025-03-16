//
//  RegistrationView.swift
//  gym-bro
//
//

import SwiftUI

struct RegistrationView: View {
    
    
    @Binding var profile: Profile
    var action: () -> Void
    
    var body: some View {
        
        
        NavigationStack {
            VStack {
                Form {
                    Section {
                        ProfileEditor(profile: $profile)
                    }
                    Section {
                        Button("Submit", action: action)
                        
                    }
                }
                
            }
            .navigationTitle("Info")
        }
    }
}

#Preview {
    @State var profile = Profile.default
    return (
        RegistrationView(profile: $profile, action: {})
    )
    
}
