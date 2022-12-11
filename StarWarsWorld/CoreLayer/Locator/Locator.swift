//
//  Locator.swift
//  StarWarsWorld
//
//  Created by Macbook on 11.12.2022.
//

import Foundation

final class Locator: NSObject  {
    
    // MARK: - Neted Types
    
    enum Scope {
        case prototype
        case singleton
    }
    
    enum Registered {
        case singleton(Any)
        case prototype((Locator) -> Any)
    }
    
    // MARK: - Type Properties
    
    @objc static let shared = Locator()
    
    // MARK: - Private Properties
    
    private var registry = SynchronizedDictionary<ServiceKey, Registered>()
    
    // MARK: - Methods
    
    func register<T>(key: T.Type,
                     name: String? = nil,
                     scope: Scope = .prototype,
                     factory: @escaping (Locator) -> T) {
        switch scope {
        case .prototype:
            registry[makeKey(key, name: name)] = .prototype(factory)
        case .singleton:
            registry[makeKey(key, name: name)] = .singleton(factory(self))
        }
    }
    
    func get<T>(_ key: T.Type, name: String? = nil) -> T? {
        let registryKey = makeKey(key, name: name)

        switch registry[registryKey] {
        case .prototype(let factory)?:
            return factory(self) as? T
        case .singleton(let instance)?:
            return instance as? T
        default:
            return nil
        }
    }
    
    func remove<T>(_ key: T.Type, name: String? = nil) {
        registry.removeValue(forKey: makeKey(key, name: name))
    }
    
    // MARK: - Resolvers
    
    func resolve<T>(_ type: T.Type, name: String? = nil) -> T {
        guard let instance = get(type, name: name) else {
            fatalError("Could not resolve \(T.self)")
        }
        return instance
    }
    
    func resolve<T>() -> T {
        resolve(T.self)
    }
    
    // MARK: - Private Methods
    
    private func makeKey(_ key: Any.Type, name: String? = nil) -> ServiceKey {
        ServiceKey(serviceType: key, name: name)
    }
}

