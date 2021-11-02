//
//  DetailViewModel.swift
//  COVIDPoint
//
//  Created by Ahtem Sitjalilov on 27.10.2021.
//

import UIKit

class DetailViewModel {
    
    weak var countryNameView: CountryNameViewProtocol?
    var progressTypes = ProgressType.allCases
    weak var histogramView: HistogramViewProtocol?
    
    /// Функция запускается в результате конфигурации DetailViewController
    func handleViewDidLoad() {
        setContentCountryBlock()
        setContentHistogramBlock()
    }
    
    /// Установить название и иконку страны
    func setContentCountryBlock() {
        countryNameView?.setName("Румыния")
        countryNameView?.setIcon("za")
    }
    
    /// Установить контент блока гистограммы
    func setContentHistogramBlock() {
        histogramView?.setTitle("Динамика заражения")
        let columns: [CGFloat] = (1...31).map { CGFloat($0) }
        histogramView?.setColumn(columns)
        histogramView?.setStartData("01 ноября 2021")
        histogramView?.setEndData("31 ноября 2021")
    }
}

extension DetailViewModel {
    enum ProgressType: CaseIterable {
        case confirmed
        case deaths
        case recovered
        
        func getName() -> String {
            switch self {
            case .confirmed:
                return "Подтверждено"
            case .deaths:
                return "Смертельные случаи"
            case .recovered:
                return "Выздоро­вевшие"
            }
        }
        
        func getCount() -> String {
            switch self {
            case .confirmed:
                return "1 486 254"
            case .deaths:
                return "43 039"
            case .recovered:
                return "1 275 351"
            }
        }
        
        func getPlusCount() -> String? {
            switch self {
            case .confirmed:
                return "+18 863"
            default:
                return ""
            }
        }
        
        func getProgress() -> Float {
            switch self {
            case .confirmed:
                return 0.7
            case .deaths:
                return 0.7
            case .recovered:
                return 0.7
            }
        }
        
        func getProgressColor() -> UIColor {
            switch self {
            case .confirmed:
                return UIColor.black
            case .deaths:
                return UIColor.red
            case .recovered:
                return UIColor.green
            }
        }
    }
}
