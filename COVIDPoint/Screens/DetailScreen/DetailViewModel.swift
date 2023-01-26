//
//  DetailViewModel.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 27.10.2021.
//

import UIKit

class DetailViewModel {
    
    weak var countryNameView: CountryNameViewProtocol?
    weak var progressConfirmed: ProgressViewProtocol?
    weak var progressDeaths: ProgressViewProtocol?
    weak var progressRecovered: ProgressViewProtocol?
    weak var histogramView: HistogramViewProtocol?
    
    /// Функция запускается в результате конфигурации DetailViewController
    func handleViewDidLoad() {
        self.setContentCountryBlock()
        self.setContentProgressBlock()
        self.setContentHistogramBlock()
    }
    
    // Функция запускается только после отображения экрана
    func handleViewDidAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.progressConfirmed?.setProgress(0.7)
            self.progressDeaths?.setProgress(0.7)
            self.progressRecovered?.setProgress(0.7)
        }
    }
    
    /// Установить название и иконку страны
    func setContentCountryBlock() {
        countryNameView?.setName("Румыния")
        countryNameView?.setIcon("za")
    }
    
    func setContentProgressBlock() {
        progressConfirmed?.setName("Подтверждено")
        progressConfirmed?.setCount("1 486 254")
        progressConfirmed?.setPlusCount("1 486 254")
        
        progressDeaths?.setName("Смертельные случаи")
        progressDeaths?.setCount("43 039")
        progressDeaths?.setPlusCount(nil)
        
        progressRecovered?.setName("Выздоро­вевшие")
        progressRecovered?.setCount("1 275 351")
        progressRecovered?.setPlusCount(nil)
    }
    
    /// Установить контент блока гистограммы
    func setContentHistogramBlock() {
        histogramView?.setTitle("Динамика заражения")
        let columns: [CGFloat] = (1...31).map { 1/31 * CGFloat($0) }
        histogramView?.setColumn(columns)
        histogramView?.setStartData("01 ноября 2021")
        histogramView?.setEndData("31 ноября 2021")
    }
}
