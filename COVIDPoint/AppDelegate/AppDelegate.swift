//
//  AppDelegate.swift
//  apicovidtest
//
//  Created by Ahtem Sitjalilov on 18.10.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        self.window?.rootViewController = MapViewController()
        self.window?.makeKeyAndVisible()
        return true
    }

}

