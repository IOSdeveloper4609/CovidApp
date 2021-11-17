//
//  ListCellViewModel.swift
//  COVIDPoint
//
//  Created by usermac on 15.11.2021.
//

import Foundation
import UIKit

protocol ListCellViewModelProtocol {
    var countryNameView: CountryNameViewProtocol? { get set }
    var progressConfirmed: ProgressViewProtocol? { get set }
    var progressDeaths: ProgressViewProtocol? { get set }
    var progressRecovered: ProgressViewProtocol? { get set }
    var histogramView: HistogramViewProtocol? { get set }
    var data: CountriesData? { get }
    func setData()
    func setProgressData()
}

class ListCellViewModel: ListCellViewModelProtocol {
    
    var countryNameView: CountryNameViewProtocol?
    var progressConfirmed: ProgressViewProtocol?
    var progressDeaths: ProgressViewProtocol?
    var progressRecovered: ProgressViewProtocol?
    var histogramView: HistogramViewProtocol?
    
    private let numberFormatter = NumberFormatter()
    
    var data: CountriesData?
    
    init(data: CountriesData) {
        self.data = data
    }
    
    func setData() {
        numberFormatter.groupingSeparator = " "
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        countryNameView?.setName(data?.name ?? "Error")
        countryNameView?.setIcon(data?.code  ?? "Error")
        
        progressConfirmed?.setName("Подтверждено")
        progressConfirmed?.setCount(numberFormatter.string(from: Int(data?.latestData.confirmed ?? 0) as NSNumber? ?? 0) ?? "")
        progressConfirmed?.setPlusCount(numberFormatter.string(from: Int(data?.today?.confirmed ?? 0) as NSNumber? ?? 0))
        
        progressDeaths?.setName("Смертельные случаи")
        progressDeaths?.setCount(numberFormatter.string(from: Int(data?.latestData.deaths ?? 0) as NSNumber? ?? 0) ?? "")
        progressDeaths?.setPlusCount(nil)
        
        progressRecovered?.setName("Выздоро­вевшие")
        progressRecovered?.setCount(numberFormatter.string(from: Int(data?.latestData.recovered ?? 0) as NSNumber? ?? 0) ?? "")
        progressRecovered?.setPlusCount(nil)
        
        histogramView?.setTitle("Динамика заражения")
        let columns: [CGFloat] = (1...31).map { 1/31 * CGFloat($0) }
        histogramView?.setColumn(columns)
        histogramView?.setStartData("01 ноября 2021")
        histogramView?.setEndData("31 ноября 2021")
    }
    
    func setProgressData() {
        guard let deathsData = self.data?.latestData.deaths,
              let confirmedData  = self.data?.latestData.confirmed,
              let recoveredData  = self.data?.latestData.recovered,
              let populationData = self.data?.population else { return }
        
        let progressConfirmedData = Double(confirmedData) / Double(populationData)
        let progressDeathsData: Double = Double(deathsData) / Double(confirmedData)
        let progressRecoveredData: Double = Double(recoveredData) / Double(confirmedData)
        
        self.progressConfirmed?.setProgress(progressConfirmedData)
        self.progressDeaths?.setProgress(progressDeathsData)
        self.progressRecovered?.setProgress(progressRecoveredData)
    }
}
