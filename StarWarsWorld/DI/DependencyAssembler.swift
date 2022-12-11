//
//  DependencyAssembler.swift
//  StarWarsWorld
//
//  Created by Macbook on 11.12.2022.
//

final class DependencyAssembler {
    
    // MARK: - Methods

    func register() {
        registerServices()
        registerFactory()
        registerAssemblies()
    }
    
    // MARK: - Private Methods
    
    private func registerServices() {
        Locator.shared.register(key: IRequestSender.self, scope: .prototype) { _ in
            RequestSender()
        }
        
        Locator.shared.register(key: IRequestFactory.self, scope: .prototype) { _ in
            RequestsFactory()
        }
        
        Locator.shared.register(key: ICoreDataStack.self, scope: .singleton) { _ in
            CoreDataStack()
        }
        
        Locator.shared.register(key: ICoreDataService.self, scope: .prototype) { resolver in
            CoreDataService(
                coreDataStack: resolver.resolve(ICoreDataStack.self)
            )
        }
    }
    
    private func registerFactory() {
        Locator.shared.register(key: IErrorAlertsFactory.self, scope: .prototype) { _ in
            ErrorAlertsFactory()
        }
    }
    
    private func registerAssemblies() {
        Locator.shared.register(key: IFilmsListAssembly.self, scope: .prototype) { resolver in
            FilmsListAssembly(
                requestSender: resolver.resolve(IRequestSender.self),
                requestFactory: resolver.resolve(IRequestFactory.self),
                coreDataService: resolver.resolve(ICoreDataService.self),
                errorAlertFactory: resolver.resolve(IErrorAlertsFactory.self),
                charactersListAssembly: resolver.resolve(ICharactersListAssembly.self)
            )
        }
        
        Locator.shared.register(key: ICharactersListAssembly.self, scope: .prototype) { resolver in
            CharactersListAssembly(
                requestSender: resolver.resolve(IRequestSender.self),
                requestFactory: resolver.resolve(IRequestFactory.self),
                coreDataService: resolver.resolve(ICoreDataService.self),
                errorAlertFactory: resolver.resolve(IErrorAlertsFactory.self),
                worldAssembly: resolver.resolve(IWorldAssembly.self)
            )
        }
        
        Locator.shared.register(key: IWorldAssembly.self, scope: .prototype) { resolver in
            WorldAssembly(
                requestSender: resolver.resolve(IRequestSender.self),
                requestFactory: resolver.resolve(IRequestFactory.self),
                errorAlertFactory: resolver.resolve(IErrorAlertsFactory.self),
                coreDataService: resolver.resolve(ICoreDataService.self)
            )
        }
    }
}

