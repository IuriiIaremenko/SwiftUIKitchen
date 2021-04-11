//
//  DragGestureAction.swift
//  
//
//  Created by Iurii Iarememko on 04.04.2021.
//

import Foundation
import SwiftUI

struct DragGestureAction: Gesture {
    enum SwipeAction {
        case up, down, left, right
    }
    @State var isDragging: Bool = false
    @State var startPos: CGPoint = .zero
    let action: (SwipeAction) -> Void

    var body: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if !isDragging {
                    startPos = gesture.location
                    isDragging.toggle()
                }
            }
            .onEnded { gesture in
                let xDist = abs(gesture.location.x - startPos.x)
                let yDist = abs(gesture.location.y - startPos.y)

                if self.startPos.y <  gesture.location.y && yDist > xDist {
                    action(.down)
                } else if self.startPos.y >  gesture.location.y && yDist > xDist {
                    action(.up)
                } else if self.startPos.x > gesture.location.x && yDist < xDist {
                    action(.left)
                } else if self.startPos.x < gesture.location.x && yDist < xDist {
                    action(.right)
                }
                isDragging.toggle()
                startPos = .zero
            }
    }
}
