//
//  CardView.swift
//  testing
//
//
// Sourced from : https://github.com/dadalar/SwiftUI-CardStackView

import SwiftUI

struct CardView<Direction, Content: View>: View {
  @State private var translation: CGSize = .zero

  private let direction: (Double) -> Direction?
  private let isOnTop: Bool
  private let onSwipe: (Direction) -> Void
  private let content: (Direction?) -> Content

  init(
    direction: @escaping (Double) -> Direction?,
    isOnTop: Bool,
    onSwipe: @escaping (Direction) -> Void,
    @ViewBuilder content: @escaping (Direction?) -> Content
  ) {
    self.direction = direction
    self.isOnTop = isOnTop
    self.onSwipe = onSwipe
    self.content = content
  }

  var body: some View {
      content(self.swipeDirection())
      .offset(self.translation)
      .rotationEffect(.degrees(Double(translation.width / 25)))
      .simultaneousGesture(self.isOnTop ? self.dragGesture() : nil)
      
      
//    GeometryReader { geometry in
//      self.content(self.swipeDirection(geometry))
//        .offset(self.translation)
//        .rotationEffect(.degrees(Double(translation.width / 25)))
//        .simultaneousGesture(self.isOnTop ? self.dragGesture(geometry) : nil)
//    }
//    .transition(transition)
  }

  private func dragGesture() -> some Gesture {
    DragGesture()
      .onChanged { value in
        self.translation = value.translation
      }
      .onEnded { value in
        self.translation = value.translation
        if let direction = self.swipeDirection() {
            withAnimation(.default) {
                self.onSwipe(direction)
                self.translation = .zero
            }
        } else {
          withAnimation { self.translation = .zero }
        }
      }
  }

  private var degree: Double {
    var degree = atan2(translation.width, -translation.height) * 180 / .pi
    if degree < 0 { degree += 360 }
    return Double(degree)
  }

  private func rotation(_ geometry: GeometryProxy) -> Angle {
    .degrees(
      Double(translation.width / geometry.size.width) * 25
    )
  }

  private func swipeDirection() -> Direction? {
    guard let direction = direction(degree) else { return nil }
    let distance = hypot(translation.width, translation.height)
    return distance > 140 ? direction : nil
  }

  private var transition: AnyTransition {
    .asymmetric(
      insertion: .identity,  // No animation needed for insertion
      removal: .offset(x: translation.width * 2, y: translation.height * 2)  // Go out of screen when card removed
    )
  }
}


#Preview {
    CardView(direction: LeftRight.direction, isOnTop: true, onSwipe: {_ in}, content: {_ in
        
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(.white)
                .stroke(.black, lineWidth: 2)
            
            VStack {
                Text("Hi")
            }
            .foregroundColor(.black)
        }
        .frame(width: 320, height: 520)
    })
}
