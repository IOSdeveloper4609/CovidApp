//
//  ThemeAppearance.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 25.10.2021.
//

import Foundation
import UIKit

/// MARK: AppearanceViewProtocol
/// Внешний вид View
protocol ThemeAppearance {
    /// Тема приложения
    var theme: ThemeProtocol { get set }
}

extension ThemeAppearance {
    /// Тема приложения
    var theme: ThemeProtocol {
        get {
            return ThemesApplicationHelper.activeTheme
        }
        set(value) {
            ThemesApplicationHelper.activeTheme = value
        }
    }
}

/// Методы для получения текущей темы
private struct ThemesApplicationHelper: LocalDataSavingProtocol {
    private let keyTheme = "UserApplicationTheme"
    private let defaultTheme = DefaultTheme()
    private let defaultThemesApplication: ThemesApplication = .defaultTheme
    
    /// Активная тема
    static var activeTheme: ThemeProtocol {
        get {
            let themeApp = ThemesApplicationHelper().getThemeFromStore()
            return ThemesApplicationHelper().getActiveThemeAppearance(theme: themeApp)
        }
        set(value) {
            let themeApp = ThemesApplicationHelper().getThemesApplicationFromThemeProtocol(value)
            ThemesApplicationHelper().saveUserTheme(themeApp)
        }
    }
    
    /// Получить активную тему с хранилища
    /// - Returns: ThemesApplication
    private func getThemeFromStore() -> ThemesApplication {
        if let theme = self.getString(target: .userDefaults, key: self.keyTheme), let intTheme = Int(theme) {
            return ThemesApplication(rawValue: intTheme) ?? self.defaultThemesApplication
        } else {
            return self.defaultThemesApplication
        }
    }
    
    /// Получить Внешний вид активной темы
    /// - Parameter theme: Тема
    /// - Returns: ThemeProtocol
    private func getActiveThemeAppearance(theme: ThemesApplication) -> ThemeProtocol {
        switch theme {
        case .defaultTheme:
            return DefaultTheme()
        case .darkTheme:
            return DarkTheme()
        }
    }
    
    /// Преобразование темы
    /// - Parameter theme: ThemeProtocol
    /// - Returns: ThemesApplication
    private func getThemesApplicationFromThemeProtocol(_ theme: ThemeProtocol) -> ThemesApplication {
        switch theme {
        case is DefaultTheme:
            return .defaultTheme
        default:
            return .darkTheme
        }
    }
    
    /// Сохранить тему
    /// - Parameter theme: ThemesApplication
    private func saveUserTheme(_ theme: ThemesApplication) {
        self.setString(target: .userDefaults, key: self.keyTheme, data: String(theme.rawValue))
    }
}
