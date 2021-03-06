//
//  UIView.swift
//  COVIDPoint
//
//  Created by user on 28.10.2021.
//

import UIKit

extension UIView {
    /// Применить Стиль
    /// - Parameter style: Стиль
    public func apply(style: Style) {
        self.backgroundColor = style.backgroundColor
        
        if let backgroundGradient = style.backgroundGradient {
            self.layer.insertSublayer(backgroundGradient, at: 0)
        }
    }
    
    /// Стиль UIView
    public struct Style {
        var backgroundColor = UIColor(red: 236.0 / 255.0, green: 236.0 / 255.0, blue: 237.0 / 255.0, alpha: 1)
        let backgroundGradient: CAGradientLayer?
        
        /// Инициализатор
        /// - Parameters:
        ///   - backgroundColor: Цвет фона
        public init(backgroundColor: UIColor,
                    backgroundGradient: CAGradientLayer? = nil) {
            self.backgroundColor = backgroundColor
            self.backgroundGradient = backgroundGradient
        }
    }
}
