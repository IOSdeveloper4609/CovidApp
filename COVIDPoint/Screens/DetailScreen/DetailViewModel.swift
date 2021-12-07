//
//  DetailViewModel.swift
//  COVIDPoint
//
//  Created by Ahtem Sitjalilov on 27.10.2021.
//

import UIKit

final class DetailViewModel {
    weak var countryNameView: CountryNameViewProtocol?
    weak var progressConfirmed: ProgressViewProtocol?
    weak var progressDeaths: ProgressViewProtocol?
    weak var progressRecovered: ProgressViewProtocol?
    
    var countryId: Int?
    private var data: CountriesData?
    private let numberFormatter = NumberFormatter()
    
    /// Функция запускается в результате конфигурации DetailViewController
    func handleViewDidLoad() {
        guard let countryId = countryId else { return }
        data = LocalSessionManager.shared.covidData?.data?[countryId]
    }
    
    // Функция запускается во время отображения экрана
    func handleViewDidAppear() {
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
            self.setData()
    }
    
    func setData() {
        numberFormatter.groupingSeparator = " "
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        guard let _data = data else { return }
        
        countryNameView?.setName(_data.name ?? "")
        countryNameView?.setIcon(_data.code  ?? "")
        
        progressConfirmed?.setName("Подтверждено".localisation())
        progressConfirmed?.setCount(numberFormatter.string(from: _data.latestData.confirmed as NSNumber? ?? 0) ?? "")
        progressConfirmed?.setPlusCount("+"  + numberFormatter.string(from: _data.today?.confirmed  as NSNumber? ?? 0)!)
        
        progressDeaths?.setName("Смертельные случаи".localisation())
        progressDeaths?.setCount(numberFormatter.string(from: _data.latestData.deaths as NSNumber? ?? 0) ?? "")
        progressDeaths?.setPlusCount(nil)
        
        progressRecovered?.setName("Выздopoвeвшие".localisation())
        progressRecovered?.setCount(numberFormatter.string(from: _data.latestData.recovered as NSNumber? ?? 0) ?? "")
        progressRecovered?.setPlusCount(nil)
    }
}
