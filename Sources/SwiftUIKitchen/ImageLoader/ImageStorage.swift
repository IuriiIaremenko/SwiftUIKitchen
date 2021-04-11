//
//  ImageStorage.swift
//  
//
//  Created by Iurii Iarememko on 05.04.2021.
//

import Foundation
import UIKit
import Combine

public protocol ImageStorage: AnyObject {
    /// Download the image by URL and store it in the cache
    /// - Parameter url: URL of the image
    @available(iOS 13.0, *)
    func getImage(for url: URL) -> AnyPublisher<UIImage?, Error>

    /// Download the image by URL and store it in the cache. Optionally assign the key to the download request, so it could be canceled later by [cancelTask(key: Int)](x-source-tag://cancelTask) for example in the `prepareForReuse` function.
    /// - Parameters:
    ///   - url: URL of the image
    ///   - key: Key to assign to download task. The key could be used to [cancelTask(key: Int)](x-source-tag://cancelTask) later.
    ///   - handler: The block to execute with the results.
    ///
    /// Example of usage
    ///
    ///        let imageKey = url.hashValue
    ///        imageStorage.getImage(for: url, key: imageKey, completion: handler)
    ///        imageStorage.cancelTask(key: imageKey)
    func getImage(for url: URL, key: Int?, completion handler: @escaping (Result<UIImage?, Error>) -> Void)

    /// Cancel download task. If the task is already completed or the key was not assigned no action is taken.
    /// - Parameter key: Key assigned to download task. If no key assigned, no actions performed.
    /// - Tag: cancelTask
    func cancelTask(key: Int)

    /// Get Image from cache if available
    /// - Parameter url: URL of the image
    func cachedImage(with url: URL) -> UIImage?

    /// Remove all cached images
    func clearStorage()
}

extension ImageStorage {
    /// Download the image by URL and store it in the cache.
    /// - Parameters:
    ///   - url: URL of the image
    ///   - handler: The block to execute with the results.
    func getImage(for url: URL, completion handler: @escaping (Result<UIImage?, Error>) -> Void) {
        getImage(for: url, key: nil, completion: handler)
    }
}
