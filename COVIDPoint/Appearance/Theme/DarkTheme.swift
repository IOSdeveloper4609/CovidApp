//
//  DarkTheme.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 25.10.2021.
//

import UIKit

/// Темная тема
class DarkTheme: ThemeProtocol {
    var colorAssets: ColorAssetsProtocol = DarkColorAssets()
    var fontAssets: FontAssetsProtocol = DarkFontAssets()
}

/// Цвета темной темы
class DarkColorAssets: ColorAssetsProtocol {
    var translucentBackground: UIColor
    var segmentControlBackground: UIColor
    var selectedSegmentControlBackground: UIColor
    
    init(translucentBackground: UIColor = .black97,
         segmentControlBackground: UIColor = .segmentGray,
         selectedSegmentControlBackground: UIColor = .white) {
        self.translucentBackground = translucentBackground
        self.segmentControlBackground = segmentControlBackground
        self.selectedSegmentControlBackground = selectedSegmentControlBackground
    }
}

/// Шрифты темной темы
class DarkFontAssets: FontAssetsProtocol {
    
}
