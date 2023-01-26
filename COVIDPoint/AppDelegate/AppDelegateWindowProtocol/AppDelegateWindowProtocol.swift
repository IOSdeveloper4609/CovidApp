//
//  AppDelegateWindowProtocol.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 22.10.2021.
//

import UIKit

/// MARK: AppDelegateWindowProtocol
/// Протокол для окна приложения
protocol AppDelegateWindowProtocol {
    /// Окно приложения
    var window: UIWindow? { get set }
    /// Начальная настройка окна приложения
    /// - Parameter appearance: Внешний вид
    func startWindowSetup(appearance: AppearanceProtocol)
}
