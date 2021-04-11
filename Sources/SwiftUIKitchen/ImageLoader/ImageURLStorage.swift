//
//  ImageURLStorage.swift
//  
//
//  Created by Iurii Iarememko on 04.04.2021.
//

import Combine
import Foundation
import class UIKit.UIImage

public final class ImageURLStorage: ImageStorage {
    public static let shared: ImageStorage = ImageURLStorage()

    private let cache: URLCache
    private let session: URLSession
    private let cacheSize: Int
    @ConcurrentSafe
    private var networkTasks = [Int: URLSessionDataTask]()

    private init(cacheSize: Int = .megaBytes(150)) {
        self.cacheSize = cacheSize
        let config = URLSessionConfiguration.default
        if #available(iOS 13.0, *) {
            cache = URLCache(memoryCapacity: cacheSize, diskCapacity: cacheSize)
        } else {
            cache = URLCache(memoryCapacity: cacheSize, diskCapacity: cacheSize, diskPath: "ImageURLStorage")
        }
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = cache
        config.httpMaximumConnectionsPerHost = 5
        config.networkServiceType = .responsiveData

        session = URLSession(configuration: config)
    }

    public func getImage(for url: URL, key: Int?, completion handler: @escaping (Result<UIImage?, Error>) -> Void) {
        let task = latestData(with: url) { [weak self] in
            if let key = key {
                self?._networkTasks.mutate {
                    $0.removeValue(forKey: key)
                }
            }
            handler($0.map(UIImage.init))
        }

        if let key = key {
            storeTask(key: key, task: task)
        }
    }

    public func cachedImage(with url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        let data = cache.cachedResponse(for: request)?.data
        return data.flatMap(UIImage.init)
    }

    public func cancelTask(key: Int) {
        _networkTasks.mutate {
            $0[key]?.cancel()
            $0.removeValue(forKey: key)
        }
    }

    public func clearStorage() {
        cache.removeAllCachedResponses()
    }
}

@available(iOS 13.0, *)
extension ImageURLStorage {
    public func getImage(for url: URL) -> AnyPublisher<UIImage?, Error> {
        latestData(with: url)
            .map(UIImage.init)
            .eraseToAnyPublisher()
    }

    private func latestData(with url: URL)  -> AnyPublisher<Data, Error> {
        let request = URLRequest(url: url)

        return session
            .dataTaskPublisher(for: request)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

extension ImageURLStorage {
    private func storeTask(key: Int, task: URLSessionDataTask) {
        _networkTasks.mutate {
            $0[key]?.cancel()
            $0[key] = task
        }
    }

    private func latestData(with url: URL, completion handler: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) { data, _, error in
            if let error = error {
                print(#function, "🧨 Request: \(request)\nError: \(error)")
                handler(.failure(error))
                return
            }

            guard let data = data else {
                print(#function, "🧨 Request: \(request) data is empty")
                handler(.success(Data()))
                return
            }
            handler(.success(data))
        }
        task.resume()
        return task
    }
}

private extension Int {
    static func megaBytes(_ number: Int) -> Int {
        number * 1024 * 1024
    }
}

