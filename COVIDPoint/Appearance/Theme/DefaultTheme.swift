//
//  DefaultTheme.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 25.10.2021.
//

import UIKit

/// Дефолтная тема (светлая)
class DefaultTheme: ThemeProtocol {
    var colorAssets: ColorAssetsProtocol = DefaultColorAssets()
    var fontAssets: FontAssetsProtocol = DefaultFontAssets()
}

/// Цвета дефолтной темы
class DefaultColorAssets: ColorAssetsProtocol {
    var translucentBackground: UIColor
    var segmentControlBackground: UIColor
    var selectedSegmentControlBackground: UIColor
    
    init(translucentBackground: UIColor = .white97,
         segmentControlBackground: UIColor = .segmentGray,
         selectedSegmentControlBackground: UIColor = .white) {
        self.translucentBackground = translucentBackground
        self.segmentControlBackground = segmentControlBackground
        self.selectedSegmentControlBackground = selectedSegmentControlBackground
    }
}

/// Шрифты дефолтной темы
class DefaultFontAssets: FontAssetsProtocol {
    
}
