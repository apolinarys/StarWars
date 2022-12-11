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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let viewControllersFactory = ViewControllersFactory()
        let router = Router(navigationController: navigationController,
                            viewControllersFactory: viewControllersFactory)
        router.initialViewController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

