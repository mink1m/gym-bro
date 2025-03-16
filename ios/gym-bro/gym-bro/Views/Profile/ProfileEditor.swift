//
//  ProfileEditor.swift
//  gym-bro
//
//

import SwiftUI

struct ProfileEditor: View {
    @Binding var profile: Profile
    
    var body: some View {

        List {
                HStack {
                    Text("First")
                    Spacer()
                    TextField("First", text: $profile.first)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Last")
                    Spacer()
                    TextField("Last", text: $profile.last)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            DatePicker(selection: $profile.dateOfBirth, displayedComponents: .date) {
                    Text("Birth Day")
                }
                HStack {
                    Text("Weight")
                        
                    Spacer()
                    
                    Picker("Feet", selection: $profile.weight) {
                        ForEach(50..<300, id: \.self) {number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .frame(height:100)
                    .pickerStyle(.wheel)
                    
                    
                    Text("lbs")
                        
                        
                }
                
                HStack {
                    Text("Height")
                        
                    
                    Picker("Feet", selection: $profile.height.feet) {
                        ForEach(3..<8, id: \.self) {number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .frame(height:100)
                    .pickerStyle(.wheel)
                    
                    
                    Text("ft")
                    Picker("Feet", selection: $profile.height.inches) {
                        ForEach(0..<12, id: \.self) {number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .frame(height:100)
                    .pickerStyle(.wheel)
                    Text("in")
                
                        
                        
                }
                
                HStack {
                    
                    Picker("Sex", selection: $profile.sex) {
                        ForEach(Profile.Sexes.allCases) { sex in
                            Text(sex.rawValue).tag(sex)
                        }
                            
                    
                    }
                }
            
                
        }
    }
}

#Preview {
    ProfileEditor(profile: .constant(.default))
}
