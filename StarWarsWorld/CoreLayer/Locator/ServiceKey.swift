//
//  ServiceKey.swift
//  StarWarsWorld
//
//  Created by Macbook on 11.12.2022.
//

struct ServiceKey {
    
    // MARK: - Properties
    
    let serviceType: Any.Type
    let name: String?
    
    // MARK: - Initialization
    
    init(serviceType: Any.Type, name: String? = nil) {
        self.serviceType = serviceType
        self.name = name
    }
}

// MARK: - Hashable

extension ServiceKey: Hashable {
    
    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(serviceType).hash(into: &hasher)
        name?.hash(into: &hasher)
    }
}

// MARK: - Equatable

extension ServiceKey: Equatable {

    static func == (lhs: ServiceKey, rhs: ServiceKey) -> Bool {
        lhs.serviceType == rhs.serviceType && lhs.name == rhs.name
    }
}

