//
//  HistogramViewProtocol.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 02.11.2021.
//

import UIKit

protocol HistogramViewProtocol: AnyObject {
    
    /// Установить название гистограммы
    func setTitle(_ text: String)
    
    /// Установить количество колонок
    func setColumn(_ countHeight: [CGFloat])
    
    /// Установить начальную дату
    func setStartData(_ text: String)
    
    /// Установить конечную дату
    func setEndData(_ text: String)
}
