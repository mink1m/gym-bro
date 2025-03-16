//
//  RatingView.swift
//  gym-bro
//
//

import SwiftUI

struct RatingView: View {
    @State var rating: Int = 3
    var onSubmit: (Int) -> Void
        
    var maximumRating = 5
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Rate the Exercise")
                .font(.title3)
            
            HStack {
                ForEach(1...maximumRating, id: \.self) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .foregroundColor(index <= rating ? .yellow : .gray)
                        .font(.system(size: 22))
                        .onTapGesture {
                            rating = index
                        }
                        
                }
            }
            
            Button(action: {
                onSubmit(rating)
            }, label: {
                Text("Submit")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            })
        }
        .padding()
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
        
        
    }
}

#Preview {
    @State var isPreseted = true
    return (
        RatingView() { rat in
            print(rat)
        }
    )
}
