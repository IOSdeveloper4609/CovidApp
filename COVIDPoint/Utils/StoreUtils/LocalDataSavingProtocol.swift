//
//  LocalDataSavingProtocol.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 25.10.2021.
//

import Foundation

public enum SavingTarget {
    case userDefaults
}

protocol LocalDataSavingProtocol {}
extension LocalDataSavingProtocol {
    /// Сохранить String
    /// - Parameters:
    ///   - key: Ключ
    ///   - data: Данные
    func setString(target: SavingTarget, key: String, data: String) {
        switch target {
        case .userDefaults:
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    /// Сохранить Bool
    /// - Parameters:
    ///   - key: Ключ
    ///   - data: Данные
    func setBool(target: SavingTarget, key: String, data: Bool) {
        switch target {
        case .userDefaults:
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    /// Сохранить Data
    /// - Parameters:
    ///   - key: Ключ
    ///   - data: Данные
    func setData(target: SavingTarget, key: String, data: Data) {
        switch target {
        case .userDefaults:
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    /// Получить String
    /// - Parameter key: Ключ
    func getString(target: SavingTarget, key: String) -> String? {
        switch target {
        case .userDefaults:
            return UserDefaults.standard.value(forKey: key) as? String
        }
    }

    /// Получить Bool
    /// - Parameter key: Ключ
    func getBool(target: SavingTarget, key: String) -> Bool? {
        switch target {
        case .userDefaults:
            return UserDefaults.standard.value(forKey: key) as? Bool
        }
    }
    
    /// Получить Data
    /// - Parameter key: Ключ
    func getData(target: SavingTarget, key: String) -> Data? {
        switch target {
        case .userDefaults:
            return UserDefaults.standard.value(forKey: key) as? Data
        }
    }
    
    /// Удалить данные
    /// - Parameter key: Ключ
    func deleteData(target: SavingTarget, key: String) {
        switch target {
        case .userDefaults:
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    /// Удалить все данные
    func removeAllData(target: SavingTarget) {
        switch target {
        case .userDefaults:
            if let appDomain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
            }
        }
    }
}
