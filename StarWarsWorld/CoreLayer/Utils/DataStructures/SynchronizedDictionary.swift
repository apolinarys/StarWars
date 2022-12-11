//
//  SynchronizedDictionary.swift
//  StarWarsWorld
//
//  Created by Macbook on 11.12.2022.
//

import Foundation

final class SynchronizedDictionary<KeyType: Hashable, ValueType>: ExpressibleByDictionaryLiteral {
    
    // MARK: - Private Properties

    private let internalDictionary: Atomic<[KeyType: ValueType]>
    
    // MARK: - Properties

    var count: Int {
        return internalDictionary.value.count
    }

    var dictionary: [KeyType: ValueType] {
        get {
            return internalDictionary.value
        }
        set {
            internalDictionary.mutate {
                $0 = newValue
            }
        }
    }
    
    // MARK: - Initialization

    init(dictionary: [KeyType: ValueType] = [:]) {
        self.internalDictionary = Atomic(dictionary)
    }
    
    convenience required init(dictionaryLiteral elements: (KeyType, ValueType)...) {
        var dictionary = [KeyType: ValueType]()

        for (key, value) in elements {
            dictionary[key] = value
        }

        self.init(dictionary: dictionary)
    }
    
    // MARK: - Subscripts

    subscript(key: KeyType) -> ValueType? {
        get {
            return internalDictionary.value[key]
        }
        set {
            set(newValue, forKey: key)
        }
    }
    
    // MARK: - Methods

    func set(_ value: ValueType?, forKey key: KeyType) {
        internalDictionary.mutate {
            $0[key] = value
        }
    }

    @discardableResult
    func removeValue(forKey key: KeyType) -> ValueType? {
        var oldValue: ValueType?

        internalDictionary.mutate {
            oldValue = $0.removeValue(forKey: key)
        }

        return oldValue
    }
}

