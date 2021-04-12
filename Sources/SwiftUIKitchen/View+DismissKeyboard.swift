//
//  View+DismissKeyboard.swift
//  CreateAccount
//
//  Created by Iurii Iaremenko on 11.03.2021.
//

import protocol SwiftUI.View
import struct SwiftUI.DragGesture
import class UIKit.UIApplication
import class UIKit.UIResponder

// GitHub Gist https://gist.github.com/IuriiIaremenko/d658ad763d1500c3d0fe255c44c88fa7
#if canImport(UIKit)
extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

extension View {
    public func dismissKeyboardOnDrag() -> some View {
        self.gesture(DragGesture().onChanged { _ in self.dismissKeyboard() })
    }
}
