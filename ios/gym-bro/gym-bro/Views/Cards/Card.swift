//
//  Card.swift
//  gym-bro
//

//
// partially modeled after: https://github.com/dadalar/SwiftUI-CardStackView

import SwiftUI

struct Card  <Content: View>: View {
    
//    @State private var dragOffset: CGSize = .zero
    @State private var color: Color
    
//    private let direction = LeftRight.direction
    private let content: () -> Content
//    private let onSwipe: (LeftRight) -> Void
//    private let isOnTop: Bool
    
    
    init (
        color: Color = Color.white,
        @ViewBuilder content: @escaping () -> Content
//        onSwipe: @escaping (LeftRight) -> Void = {_ in},
//        isOnTop: Bool = true
    ) {
        self.content = content
//        self.onSwipe = onSwipe
//        self.isOnTop = isOnTop
        self.color = color
    }
   
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(color)
                .stroke(.black, lineWidth: 2)
            
            
            
            VStack {
                content()
            }
            .foregroundColor(.black)
        }
        .frame(width: 320, height: 520)
//        .offset(x: dragOffset.width, y: dragOffset.height * 0.1)
//        .offset(dragOffset)
//        .rotationEffect(.degrees(Double(dragOffset.width / 25)))
//        .rotationEffect(.degrees(Double(dragOffset.width / 320) * 25))
//        .gesture(isOnTop ? dragGesture() : nil)
    }
    
//    private func dragGesture() -> some Gesture {
//        DragGesture()
//            .onChanged { value in
//                dragOffset = value.translation
////                print(dragOffset, degree)
//                withAnimation{
//                    changeColor(width: dragOffset.width)
//                }
//            }
//            .onEnded { value in
//                
//                if let direction = swipeDirection() {
//                    onSwipe(direction)
//                    withAnimation{
//                        changeColor(width: dragOffset.width)
//                        }
//                } else {
//                    withAnimation {
//                        dragOffset = .zero
//                        changeColor(width: dragOffset.width)
//                    }
//                }
//                
//                
//                
//            }
//    }
//    
//    private var degree: Double {
//        var degree = atan2(dragOffset.width, -dragOffset.height) * 180 / .pi
//        if degree < 0 { degree += 360 }
//        return Double(degree)
//    }
//    
//    private func swipeDirection() -> LeftRight? {
//        guard let direction = direction(degree) else {return nil}
//        let distance = hypot(dragOffset.width, dragOffset.height)
//        print(distance)
//        return distance > 220 ? direction : nil
//    }
//    
//    private func swipeCard(width: CGFloat) {
//        switch width {
//        case -500...(-150):
//            print("BOO")
//            dragOffset = CGSize(width: -500, height: 0)
//        case 150...500:
//            print("WOO")
//            dragOffset = CGSize(width: 500, height: 0)
//        default:
//            dragOffset = .zero
//        }
//    }
//    
//    private func changeColor(width: CGFloat) {
//        switch width {
//        case -500...(-130):
//            color = .red
//        case 130...500:
//            color = .green
//        default:
//            color = .white
//        }
//    }
}

#Preview {
    Card {
        Text("Hi")
    }
//    Card( content: {
//        Text("hi")
//    }, onSwipe: {
//        lr in
//        print(lr, "yea")
//    }, isOnTop: true)
}
