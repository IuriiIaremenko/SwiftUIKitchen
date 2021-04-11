//
//  Loader.swift
//  LexIcon
//
//  Created by Iurii Iarememko on 27.03.2021.
//

import SwiftUI

struct Loader: ViewModifier {
    var isLoading: Bool

    var loaderView: some View {
        HStack(alignment: .center, spacing: 20) {
            Group {
                CircleLoaderView(startDelay: 0)
                CircleLoaderView(startDelay: 0.5)
                CircleLoaderView(startDelay: 1)
            }
            .fixedSize()
        }
    }

    @ViewBuilder func body(content: Content) -> some View {
        if isLoading {
            content
                .blur(radius: 2, opaque: false)
                .overlay(loaderView)
        } else {
            content
        }
    }
}
