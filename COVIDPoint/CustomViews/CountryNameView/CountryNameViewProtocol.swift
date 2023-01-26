//
//  CountryNameViewProtocol.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 27.10.2021.
//

import UIKit

protocol CountryNameViewProtocol: AnyObject {
    
    /// Установить название страны
    func setName(_ text: String)
    
    /// Установить флаг страны
    func setIcon(_ countryCode: String)
}
