//
//  CustomInput.swift
//  gym-bro
//

//

import SwiftUI

struct CustomInput: View {
    
    let label: String
    @Binding var field_value: String
    let systemImageName: String
    
    var body: some View {
        HStack {
              Image(systemName: systemImageName)
                .imageScale(.large)
                .padding(.leading)

              TextField(label, text: $field_value)
                .padding(.vertical)
                .autocapitalization(.none)
                .autocorrectionDisabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
            .background(
              RoundedRectangle(cornerRadius: 16.0, style: .circular)
                .foregroundColor(Color(.secondarySystemFill))
            )
    }
}
