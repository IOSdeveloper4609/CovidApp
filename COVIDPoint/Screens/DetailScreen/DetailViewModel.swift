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
    
    var countryIndex: Int?
    var data: CountriesData?
    
    /// Функция запускается в результате конфигурации DetailViewController
    func handleViewDidLoad() {
        guard let id = countryIndex else { return }
        data = LocalSessionManager.shared.covidData?.data?[id]
        
    }
    
    // Функция запускается только после отображения экрана
    func handleViewDidAppear() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.progressConfirmed?.setProgress(0.7)
            self.progressDeaths?.setProgress(0.7)
            self.progressRecovered?.setProgress(0.7)
        }
    }
    
    func setData() {
        
        countryNameView?.setName(data?.name ?? "Error")
        countryNameView?.setIcon(data?.code  ?? "Error")
        
        progressConfirmed?.setName("Подтверждено")
        progressConfirmed?.setCount("\(data?.latestData.confirmed ?? 0)")
        progressConfirmed?.setPlusCount("\(data?.today?.confirmed ?? 0)")
        
        progressDeaths?.setName("Смертельные случаи")
        progressDeaths?.setCount("\(data?.latestData.deaths ?? 0)")
        progressDeaths?.setPlusCount(nil)
        
        progressRecovered?.setName("Выздоро­вевшие")
        progressRecovered?.setCount("\(data?.latestData.recovered ?? 0)")
        progressRecovered?.setPlusCount(nil)
        
        histogramView?.setTitle("Динамика заражения")
        let columns: [CGFloat] = (1...31).map { 1/31 * CGFloat($0) }
        histogramView?.setColumn(columns)
        histogramView?.setStartData("01 ноября 2021")
        histogramView?.setEndData("31 ноября 2021")
    }
}
