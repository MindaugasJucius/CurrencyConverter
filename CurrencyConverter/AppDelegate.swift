//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 08/11/2019.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CurrencyPairCreationCoordinatorViewController()
        window?.makeKeyAndVisible()
        return true
    }

}

