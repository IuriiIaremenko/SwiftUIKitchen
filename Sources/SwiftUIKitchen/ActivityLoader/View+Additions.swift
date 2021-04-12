//
//  View+Additions.swift
//  LexIcon
//
//  Created by Iurii Iarememko on 27.03.2021.
//

import SwiftUI

public extension View {
    func loader(isLoading: Bool) -> some View {
        self.modifier(Loader(isLoading: isLoading))
    }
}

public extension View {
    func animateForever(using animation: Animation = Animation.easeInOut(duration: 1), delay: Double = 0, autoreverses: Bool = false, _ action: @escaping () -> Void) -> some View {
        let repeated = animation
            .repeatForever(autoreverses: autoreverses)
            .delay(delay)

        return onAppear {
            withAnimation(repeated) {
                action()
            }
        }
    }
}
