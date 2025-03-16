//
//  TimerButtonBase.swift
//  gym-bro
//

//

import SwiftUI

struct TimerButtonBase: View {
    
    
    var buttonText: String
    var progress: Double
    var clickAction: () -> Void
    
    var body: some View {
            Button(action: clickAction) {
                Text(buttonText)
                    .foregroundColor(.white)
                    .padding(.horizontal, 90)
                    .padding(.vertical, 15)
                    .background(
                        ZStack {
                            Capsule()
                                .fill(progress >= 0.8 ? Color.red : .gray)
                                .animation(.linear, value: progress)
                            
                            Capsule()
                                .trim(from: 0, to: CGFloat(progress))
                                .stroke(progress >= 0.7 ? Color.red :  Color.green, lineWidth: 4)
                                .rotationEffect(.degrees(0))
                                .animation(.linear(duration: 1.0), value: progress)
                            
                        }
                    )
            }
        
    }
}

#Preview {
    TimerButtonBase(buttonText: "test", progress: 0.3, clickAction: {})
}
