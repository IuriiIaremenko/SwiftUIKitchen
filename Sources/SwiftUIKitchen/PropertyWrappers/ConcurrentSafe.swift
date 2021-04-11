//
//  ConcurrentSafe.swift
//  
//
//  Created by Iurii Iarememko on 05.04.2021.
//

import Foundation

/// Property wrapper for safe access and modification of the value across multiple thread/queues.
@propertyWrapper
public struct ConcurrentSafe<Value> {
    private let lock: NSRecursiveLock
    private var value: Value

    public init(wrappedValue: Value) {
        lock = .init()
        value = wrappedValue
        lock.name = String(describing: value)
    }

    public var wrappedValue: Value {
        get {
            lock.lock()
            defer { lock.unlock() }
            return value
        }
        set {
            /// Mutation of the array, dictionary, set, etc must be performed inside the mutate function otherwise data race will occur.
            assert(!(self is Invalid || value is Invalid), "Error please use mutate function instead!")
            lock.lock()
            defer { lock.unlock() }
            value = newValue
        }
    }

    public mutating func mutate(_ mutation: (inout Value) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        mutation(&value)
    }

    public mutating func mutate(_ mutation: (inout Value) throws -> Void) rethrows {
        lock.lock()
        defer { lock.unlock() }
        try mutation(&value)
    }
}

private protocol Invalid { }
extension ConcurrentSafe: Invalid where Value: Sequence { }
extension Array: Invalid { }
