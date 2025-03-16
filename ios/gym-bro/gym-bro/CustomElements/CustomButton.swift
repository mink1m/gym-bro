//
//  CustomButton.swift
//  gym-bro
//

//

import SwiftUI

struct CustomButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            
            HStack {
                    Spacer()
                    Text(text)
                      .padding()
                      .accentColor(.white)
                    Spacer()
                  }
        }
        .background(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 16.0))
    }
}


#Preview {
    CustomButton(text: "Test") {
        
    }
}
