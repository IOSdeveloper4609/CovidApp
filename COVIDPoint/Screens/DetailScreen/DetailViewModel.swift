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
    
    var countryId: Int?
    private var data: CountriesData?
    private let numberFormatter = NumberFormatter()
    
    /// Функция запускается в результате конфигурации DetailViewController
    func handleViewDidLoad() {
        guard let countryId = countryId else { return }
        data = LocalSessionManager.shared.covidData?.data?[countryId]
    }
    
    // Функция запускается только после отображения экрана
    func handleViewDidAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
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
}
