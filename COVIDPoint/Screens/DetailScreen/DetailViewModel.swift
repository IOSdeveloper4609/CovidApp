//
//  DetailViewModel.swift
//  COVIDPoint
//
//  Created by Ahtem Sitjalilov on 27.10.2021.
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
        setContentCountryBlock()
        setContentProgressBlock()
        setContentHistogramBlock()
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
        progressConfirmed?.setProgress(0.7)
        progressConfirmed?.setProgressColor(UIColor.black)
        
        progressDeaths?.setName("Смертельные случаи")
        progressDeaths?.setCount("43 039")
        progressDeaths?.setPlusCount(nil)
        progressDeaths?.setProgress(0.7)
        progressDeaths?.setProgressColor(UIColor.red)
        
        progressRecovered?.setName("Выздоро­вевшие")
        progressRecovered?.setCount("1 275 351")
        progressRecovered?.setPlusCount(nil)
        progressRecovered?.setProgress(0.7)
        progressRecovered?.setProgressColor(UIColor.green)
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
