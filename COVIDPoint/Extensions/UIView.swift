//
//  UIView.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 28.10.2021.
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
        let backgroundColor: UIColor
        let backgroundGradient: CAGradientLayer?
        
        /// Инициализатор
        /// - Parameters:
        ///   - backgroundColor: Цвет фона
        public init(backgroundColor: UIColor = .clear,
                    backgroundGradient: CAGradientLayer? = nil) {
            self.backgroundColor = backgroundColor
            self.backgroundGradient = backgroundGradient
        }
    }
}
