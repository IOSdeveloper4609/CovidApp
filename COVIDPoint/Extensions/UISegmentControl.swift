//
//  UISegmentControl.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 29.10.2021.
//

import UIKit

extension UISegmentedControl {
    /// Применить Стиль
    /// - Parameter style: Стиль
    public func apply(style: Style) {
        self.backgroundColor = style.backgroundColor
    }
    
    /// Стиль UISegmentedControl
    public struct Style {
        let backgroundColor: UIColor
        let selectedViewColor: UIColor
        
        /// Инициализатор
        /// - Parameters:
        ///   - backgroundColor: Цвет фона
        ///   - selectedViewColor: Цвет выбранного сегмента
        public init(backgroundColor: UIColor,
                    selectedViewColor: UIColor) {
            self.backgroundColor = backgroundColor
            self.selectedViewColor = selectedViewColor
        }
    }
}

