//
//  AppDelegate.swift
//  UnsplashTest
//
//  Created by bitocto_Barry on 08/03/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        imageDataCache.removeAllObjects()
        
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: CollectionRouter.createModule())
        window?.makeKeyAndVisible()
                
        return true
    }

}

enum ApiError {
    case URL, Connection, Json
}

