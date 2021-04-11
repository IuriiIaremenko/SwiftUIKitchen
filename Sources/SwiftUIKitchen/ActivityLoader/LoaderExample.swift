//
//  LoaderExample.swift
//  LexIcon
//
//  Created by Iurii Iarememko on 21.03.2021.
//

import SwiftUI

struct LoaderExample: View {
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            Text("Hello, World!")
                .loader(isLoading: isLoading)
            Text("Hello, World2!")
                .loader(isLoading: !isLoading)
            Button("Toggle loading") {
                isLoading.toggle()
            }
        }
    }
}

struct LoaderExample_Previews: PreviewProvider {
    static var previews: some View {
        LoaderExample()
            .previewLayout(.sizeThatFits)
    }
}
