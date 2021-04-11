//
//  File.swift
//  
//
//  Created by Iurii Iarememko on 04.04.2021.
//

import SwiftUI

public struct PagerView<Content: View>: View {
    let pageCount: Int
    let itemWidth: CGFloat
    let content: Content
    let minimumDistance: CGFloat = 20
    @Binding var currentIndex: Int
    @GestureState private var translation: CGFloat = 0
    private let itemChangeWidth: CGFloat

    public init(pageCount: Int, currentIndex: Binding<Int>, itemWidth: CGFloat, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
        self.itemWidth = itemWidth
        itemChangeWidth = itemWidth / 4
    }

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: minimumDistance)
            .updating(self.$translation) { value, translation, _ in
                translation = value.translation.width
            }
            .onEnded { value in
                currentIndex = getPageIndex(value)
            }
    }

    public var body: some View {
        if #available(iOS 14.0, *) {
            LazyHStack(spacing: 0) {
                self.content
            }
            .frame(width: itemWidth, alignment: .leading)
            .offset(x: -CGFloat(currentIndex) * itemWidth)
            .offset(x: translation)
            .animation(.linear(duration: 0.2))
            .gesture(dragGesture)
        } else {
            HStack(spacing: 0) {
                self.content
            }
            .frame(width: itemWidth, alignment: .leading)
            .offset(x: -CGFloat(currentIndex) * itemWidth)
            .offset(x: translation)
            .animation(.linear(duration: 0.2))
            .gesture(dragGesture)
        }
    }
}

private extension PagerView {
    private func getPageIndex(_ value: GestureStateGesture<DragGesture, CGFloat>.Value) -> Int {
        var newIndex: Int = currentIndex
        if value.translation.width > itemWidth / 4 {
            newIndex = currentIndex - 1
        } else if value.translation.width < -itemWidth / 4  {
            newIndex = currentIndex + 1
        }
        return min(max(newIndex, 0), pageCount - 1)
    }

    private func isPageChangeNeeded(width: CGFloat) -> Bool {
        !(-itemChangeWidth...itemChangeWidth).contains(width)
    }
}

struct PagerView_Previews: PreviewProvider {
    struct PagerTestView: View {
        @State private var currentPage = 3
        let totalPages: Int = 6
        let width = UIScreen.main.bounds.width

        var body: some View {
            PagerView(pageCount: totalPages, currentIndex: $currentPage, itemWidth: width) {
                Group {
                    Color.blue
                    Color.black
                    Color.green
                    Color.yellow
                    Color.red
                    Color.gray
                }
                .frame(width: width)
            }
        }
    }

    static var previews: some View {
        PagerTestView()
//            .previewLayout(.sizeThatFits)
    }
}

