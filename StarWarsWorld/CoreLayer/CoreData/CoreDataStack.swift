//
//  CoreDataStack.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import CoreData

private extension String {
    static let coreDataStackContainerName = "CoreDataModel"
}

protocol ICoreDataStack {
    
    // MARK: - Methods
    
    func fetch<T>(fetchRequest: NSFetchRequest<T>) -> [T]?
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void)
    func getContext() -> NSManagedObjectContext
}

final class CoreDataStack: ICoreDataStack {
    
    // MARK: - Private Properties
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: String.coreDataStackContainerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                Logger.shared.message(error.localizedDescription)
            }
        }
        return container
    }()
    
    // MARK: - ICoreDataStack
    
    func getContext() -> NSManagedObjectContext {
        container.viewContext
    }
    
    func fetch<T>(fetchRequest: NSFetchRequest<T>) -> [T]? {
        try? container.viewContext.fetch(fetchRequest)
    }
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = container.viewContext
        context.perform { [weak self] in
            block(context)
            if context.hasChanges {
                do {
                    try self?.performSave(in: context)
                } catch {
                    Logger.shared.message(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func performSave(in context: NSManagedObjectContext) throws {
        try context.save()
        if let parent = context.parent {
            try performSave(in: parent)
        }
    }
}
