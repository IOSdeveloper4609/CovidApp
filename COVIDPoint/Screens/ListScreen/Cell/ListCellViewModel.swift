//
//  ListCellViewModel.swift
//  COVIDPoint
//
//  Created by usermac on 15.11.2021.
//

import Foundation
import UIKit


protocol ListCellViewModelProtocol {
   func getData()
    var countryNameView: CountryNameViewProtocol? { get set }
    var progressView: ProgressViewProtocol? { get set }
    var progressDeaths: ProgressViewProtocol? { get set }
    var progressRecovered: ProgressViewProtocol? { get set }
    var histogramView: HistogramViewProtocol? { get set }
}

class ListCellViewModel: ListCellViewModelProtocol {
    
    var data = LocalSessionManager.shared.covidData?.data
    
    var countryNameView: CountryNameViewProtocol?
    var progressView: ProgressViewProtocol?
    var progressDeaths: ProgressViewProtocol?
    var progressRecovered: ProgressViewProtocol?
    var histogramView: HistogramViewProtocol?
    
    
    func getData() {
        countryNameView?.setName(data?.first?.name ?? "")
        countryNameView?.setIcon(data?.first?.code ?? "")
        progressView?.setName("Подтверждено")
        progressView?.setCount("\(data?.first?.latestData.confirmed ?? 0)")
        progressView?.setPlusCount("\(data?.first?.today?.confirmed ?? 0)")

        progressDeaths?.setName("Смертельные случаи")
        progressDeaths?.setCount("\(data?.first?.latestData.deaths ?? 0)")
        progressDeaths?.setPlusCount(nil)

        progressRecovered?.setName("Выздоро­вевшие")
        progressRecovered?.setCount("\(data?.first?.latestData.recovered ?? 0)")
        progressRecovered?.setPlusCount(nil)

        histogramView?.setTitle("Динамика заражения")
        let columns: [CGFloat] = (1...31).map { 1/31 * CGFloat($0) }
        histogramView?.setColumn(columns)
        histogramView?.setStartData("01 ноября 2021")
        histogramView?.setEndData("31 ноября 2021")
    }
    
}
