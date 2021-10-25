//
//  DefaultTheme.swift
//  COVIDPoint
//
//  Created by user on 25.10.2021.
//

import UIKit

/// Дефолтная тема (светлая)
class DefaultTheme: ThemeProtocol {
    var colorAssets: ColorAssetsProtocol = DefaultColorAssets()
    var fontAssets: FontAssetsProtocol = DefaultFontAssets()
}

/// Цвета дефолтной темы
class DefaultColorAssets: ColorAssetsProtocol {
    
}

/// Шрифты дефолтной темы
class DefaultFontAssets: FontAssetsProtocol {
    
}
