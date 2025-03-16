//
//  CardStateController.swift
//  gym-bro
//
//

import SwiftUI

public enum CardStates: CaseIterable {
    case start
    case swiping
    case active
    case reviewing
    case moreInfo
    case end
}

struct BaseCardStateController: View {
    
    // external argumetns
    @Binding var data: [Exercise]
    var currIndex: Int
    var currState: CardStates
    var cardTransition: (FourDirections) -> Void

    
    // params
    var maxVisableCards = 2
        
    
    func transition(direction: FourDirections) {
        
        cardTransition(direction)
        
    }
    
    func isActive(state: CardStates) -> Bool {
        return state == currState
    }
    
    var body: some View {
        
        ZStack {
            endCard()
            startCard()
            ForEach(data.indices.reversed(), id: \.self) { index -> AnyView in
                let relativeIndex = self.data.distance(from: self.currIndex, to: index)
                if relativeIndex >= 0 && relativeIndex < self.maxVisableCards && index >= 0 && index < data.endIndex {
                    return AnyView(self.swipingCard(index: index, relativeIndex: relativeIndex))
                } else {
                    return AnyView(EmptyView())
                }
            }
            
            if(currIndex < data.endIndex) {
                activeCard(index: currIndex)
                moreInfoCard(index: currIndex)
            }
            
        }
    }
    
    private func startCard() -> some View {
        CardView(
            direction: FourDirections.direction,
            isOnTop: isActive(state: CardStates.start),
            onSwipe: { direction in
                transition(direction: direction)
            },
            content: { direction in
                BaseCard()
                .frame(width: 320, height: 520)
                    .offset(
                      x: CGFloat(isActive(state: CardStates.start) ? 0 : 450),
                      y: CGFloat(isActive(state: CardStates.start) ? 0 : 50)
                    )
            })
    }
    private func swipingCard(index: Int, relativeIndex: Int) -> some View {
        
        CardView(
            direction: FourDirections.direction,
            isOnTop: isActive(state: CardStates.swiping),
            onSwipe: { direction in
                transition(direction: direction)
            },
            content: { direction in
                WorkoutPreviewCard(exercise: data[index])
                    .offset(
                      x: CGFloat(isActive(state: CardStates.swiping) ? 0 : 450),
                      y: CGFloat(isActive(state: CardStates.swiping) ? 0 : 50)
                    )
            })
    }
    private func activeCard(index: Int) -> some View {
        CardView(
            direction: FourDirections.direction,
            isOnTop: isActive(state: CardStates.active),
            onSwipe: { direction in
                transition(direction: direction)
            },
            content: { direction in
                ActiveExcerciseCard(exercise: $data[index])
                    .offset(
                      x: CGFloat(isActive(state: CardStates.active) ? 0 : 450),
                      y: CGFloat(isActive(state: CardStates.active) ? 0 : 50)
                    )
            })
    }
    private func moreInfoCard(index: Int) -> some View {
        CardView(
            direction: FourDirections.direction,
            isOnTop: isActive(state: CardStates.moreInfo),
            onSwipe: { direction in
                transition(direction: direction)
            },
            content: { direction in
                MoreInfoCard(exercise: data[index])
                .frame(width: 320, height: 520)
                    .offset(
                      x: CGFloat(isActive(state: CardStates.moreInfo) ? 0 : 0),
                      y: CGFloat(isActive(state: CardStates.moreInfo) ? 0 : -900)
                    )
            })
    }
    
    private func endCard() -> some View {
        CardView(
            direction: FourDirections.direction,
            isOnTop: isActive(state: CardStates.end),
            onSwipe: { direction in
                transition(direction: direction)
            },
            content: { direction in
                Card(color: Color(red: 0.1686, green: 0.1686, blue: 0.1686)) {
                    Text("That's all")
                }
                .frame(width: 320, height: 520)
            })
    }
    
}

#Preview {
    
    @State var data = [
        Exercise.default,
        Exercise.default
    ]
    
    @State var currState = CardStates.start
    
    return (
        BaseCardStateController(data: $data, currIndex: 0, currState: currState, cardTransition: {dir in print(dir)})
    )
}
