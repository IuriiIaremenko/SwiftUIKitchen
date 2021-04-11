//
//  ImageLoader.swift
//  
//
//  Created by Iurii Iarememko on 04.04.2021.
//

import UIKit
import Combine
import struct SwiftUI.Image
import protocol SwiftUI.View

public final class ImageLoader: ObservableObject {
    @Published public var image: UIImage? = nil
    private var subscriptions = Set<AnyCancellable>()

    public init(url: URL?, placeholder: UIImage? = nil) {
        guard let url = url else {
            return
        }
        image = placeholder

        ImageURLStorage.shared
            .cachedImage(with: url)
            .map { image = $0 }

        ImageURLStorage.shared
            .getImage(for: url)
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    guard let self = self else { return }
                    self.image = $0
                })
            .store(in: &subscriptions)
    }
}


public extension Image {
    init?(loader: ImageLoader) {
        guard let image = loader.image else {
            return nil
        }

        self.init(uiImage: image)
    }

    func resizableFill() -> some View {
        resizable()
            .aspectRatio(contentMode: .fill)
    }
}
