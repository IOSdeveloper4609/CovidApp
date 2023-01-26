//
//  AppDelegate.swift
//  apicovidtest
//
//  Created by Azat Kirakosyan on 18.10.2021.
//

import UIKit

/// MARK: Appearance
extension AppDelegate {
    /// Внешний вид
    struct Appearance: AppearanceProtocol {
    }
}

/// MARK: AppDelegate
@main
class AppDelegate: UIResponder, UIApplicationDelegate, LaunchAppProtocol {
    /// Окно приложения
    var window: UIWindow?
    ///  Внешний вид
    var appearance: Appearance = .init()

    /// Приложение запустилось
    /// - Parameters:
    ///   - application: UIApplication
    ///   - launchOptions: [UIApplication.LaunchOptionsKey: Any]
    /// - Returns: Bool
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Начальная настройка окна приложения
        self.startWindowSetup(appearance: self.appearance)
        /// Настройка после запуска приложения
        self.setupLaunch()
        return true
    }

}

/// MARK: AppDelegateWindowProtocol, ModeApplicationProtocol
extension AppDelegate: AppDelegateWindowProtocol {
    /// Начальная настройка окна приложения
    /// - Parameter appearance: Внешний вид
    func startWindowSetup(appearance: AppearanceProtocol) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        let splashVM = SplashViewModel(requestManager: SplashRequestManager(),
                                 localSessionManager: LocalSessionManager.shared)
        let splashVC = SplashViewController(viewModel: splashVM)
        self.window?.rootViewController = splashVC
        self.window?.makeKeyAndVisible()
    }
}

