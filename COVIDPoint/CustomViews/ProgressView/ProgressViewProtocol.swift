//
//  DetailCountryViewProtocol.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 27.10.2021.
//

import UIKit

protocol ProgressViewProtocol: AnyObject {
    
    /// Установить тип progressView
    func setName(_ text: String)
    
    /// Установить значение
    func setCount(_ text: String)
    
    /// Установить дополнительное значение
    func setPlusCount(_ text: String?)
    
    /// Установить значение прогресса
    func setProgress(_ value: CGFloat)
    
    /// Установить цвет прогресса
    func setProgressGradientColor(_ color: [UIColor])
}
