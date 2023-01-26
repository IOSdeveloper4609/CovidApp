//
//  ThemeProtocol.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 25.10.2021.
//

import UIKit

/// Тема
protocol ThemeProtocol {
    var colorAssets: ColorAssetsProtocol { get }
    var fontAssets: FontAssetsProtocol { get }
}

/// Цвета
protocol ColorAssetsProtocol {
    var translucentBackground: UIColor { get }
    var segmentControlBackground: UIColor { get }
    var selectedSegmentControlBackground: UIColor { get }
}

/// Шрифты
protocol FontAssetsProtocol {
    
}
