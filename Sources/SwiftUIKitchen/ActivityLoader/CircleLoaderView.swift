//
//  CircleLoaderView.swift
//  LexIcon
//
//  Created by Iurii Iarememko on 27.03.2021.
//

import Foundation
import SwiftUI

struct CircleLoaderView: View {
    @State var scale: CGFloat = 2
    let startDelay: Double

    var body: some View {
        Circle()
            .foregroundColor(.blue)
            .scaleEffect(scale)
            .animateForever(delay: startDelay, autoreverses: true) { scale = 0.5 }
    }
}
