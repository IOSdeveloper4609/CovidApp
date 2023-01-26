//
//  ListCellViewModel.swift
//  COVIDPoint
//
//  Created by Азат Киракосян on 15.11.2021.
//

import Foundation
import UIKit

protocol ListCellViewModelProtocol: AnyObject {
    var countryNameView: CountryNameViewProtocol? { get set }
    var progressConfirmed: ProgressViewProtocol? { get set }
    var progressDeaths: ProgressViewProtocol? { get set }
    var progressRecovered: ProgressViewProtocol? { get set }
    var data: CountriesData? { get }
    var isSelected: Bool { get }
    func setData()
    func setProgressData()
}

final class ListCellViewModel: ListCellViewModelProtocol {
    var countryNameView: CountryNameViewProtocol?
    var progressConfirmed: ProgressViewProtocol?
    var progressDeaths: ProgressViewProtocol?
    var progressRecovered: ProgressViewProtocol?
        
    var isSelected: Bool
    var data: CountriesData?
    
    private let numberFormatter = NumberFormatter()
    
    init(data: CountriesData,
         isSelected: Bool) {
        self.data = data
        self.isSelected = isSelected
    }
    
    func setData() {
        numberFormatter.groupingSeparator = " "
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        countryNameView?.setName(data?.name ?? "")
        countryNameView?.setIcon(data?.code  ?? "")
        
        progressConfirmed?.setName("Подтверждено")
        progressConfirmed?.setCount(numberFormatter.string(from: Int(data?.latestData.confirmed ?? 0) as NSNumber? ?? 0) ?? "")
        progressConfirmed?.setPlusCount("+" + numberFormatter.string(from: Int(data?.today?.confirmed ?? 0) as NSNumber? ?? 0)!)
        
        progressDeaths?.setName("Смертельные случаи")
        progressDeaths?.setCount(numberFormatter.string(from: Int(data?.latestData.deaths ?? 0) as NSNumber? ?? 0) ?? "")
        progressDeaths?.setPlusCount(nil)
        
        progressRecovered?.setName("Выздopoвeвшие")
        progressRecovered?.setCount(numberFormatter.string(from: Int(data?.latestData.recovered ?? 0) as NSNumber? ?? 0) ?? "")
        progressRecovered?.setPlusCount(nil)
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
