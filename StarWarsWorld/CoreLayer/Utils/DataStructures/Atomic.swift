//
//  Atomic.swift
//  StarWarsWorld
//
//  Created by Macbook on 11.12.2022.
//

import Foundation

final class Atomic<T> {
    
    // MARK: - Private Properties
    
    private var _value: T

    private let lock = NSRecursiveLock()
    
    // MARK: - Properties
    
    var value: T {
        lock.lock()
        defer { lock.unlock() }
        return _value
    }
    
    // MARK: - Initialization
    
    init(_ initialValue: T) {
        self._value = initialValue
    }
    
    // MARK: - Type Methods
    
    static func array(of type: T.Type) -> Atomic<[T]> {
        Atomic<[T]>([T]())
    }
    
    // MARK: - Methods

    func mutate(_ transform: (inout T) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        transform(&_value)
    }
}
