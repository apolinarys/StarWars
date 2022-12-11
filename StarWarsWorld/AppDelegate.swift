//
//  AppDelegate.swift
//  StarWarsWorld
//
//  Created by Macbook on 07.12.2022.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let dependencyAssembler = DependencyAssembler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        dependencyAssembler.register()
        
        let filmsListAssembly = Locator.shared.resolve(IFilmsListAssembly.self)
        
        window?.rootViewController = filmsListAssembly.assemble()
        window?.makeKeyAndVisible()
        
        return true
    }
}

