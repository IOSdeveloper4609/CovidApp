//
//  CustomCell.swift
//  COVIDPoint
//
//  Created by usermac on 11.11.2021.
//

import UIKit


extension ListCell {
    struct Layout {
        var stackViewInsets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 20)
        var stackViewSpacing: CGFloat = 14
    }

    struct Appearance {
       
        
    }
}

final class ListCell: BaseCell {
    
    let layout = Layout()
    let appearances = Appearance()
    var countryNameViewProtocol: CountryNameViewProtocol?
    var progressViewProtocol: ProgressViewProtocol?
    var progressDeathsProtocol: ProgressViewProtocol?
    var progressRecoveredProtocol: ProgressViewProtocol?
    var histogramViewProtocol: HistogramViewProtocol?
    let countryName = CountryNameView()
    var progressConfirmed = ProgressView()
    let progressDeaths = ProgressView()
    let progressRecovered = ProgressView()
    let histogramView = HistogramView()
    var stackView = UIStackView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
        addAndSetupSubviews(layout: layout)
        setData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithModel(data: CountriesData) {
        countryNameViewProtocol?.setName(data.name ?? "")
        countryNameViewProtocol?.setIcon(data.code ?? "")
        progressViewProtocol?.setName("Подтверждено")
        progressViewProtocol?.setCount("\(data.latestData.confirmed ?? 0)")
        progressViewProtocol?.setPlusCount("\(data.today?.confirmed ?? 0)")

        progressDeathsProtocol?.setName("Смертельные случаи")
        progressDeathsProtocol?.setCount("\(data.latestData.deaths ?? 0)")
        progressDeathsProtocol?.setPlusCount(nil)

        progressRecoveredProtocol?.setName("Выздоро­вевшие")
        progressRecoveredProtocol?.setCount("\(data.latestData.recovered ?? 0)")
        progressRecoveredProtocol?.setPlusCount(nil)

        histogramViewProtocol?.setTitle("Динамика заражения")
        let columns: [CGFloat] = (1...31).map { 1/31 * CGFloat($0) }
        histogramViewProtocol?.setColumn(columns)
        histogramViewProtocol?.setStartData("01 ноября 2021")
        histogramViewProtocol?.setEndData("31 ноября 2021")
    }
    
    func setData() {
        countryNameViewProtocol = countryName
        progressViewProtocol = progressConfirmed
        progressDeathsProtocol = progressDeaths
        progressRecoveredProtocol = progressRecovered
        histogramViewProtocol = histogramView
    }
    
    func addAndSetupSubviews(layout: ListCell.Layout) {
        /// настройка stackView
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(countryName)
        stackView.addArrangedSubview(progressConfirmed)
        stackView.addArrangedSubview(progressDeaths)
        stackView.addArrangedSubview(progressRecovered)
        stackView.addArrangedSubview(histogramView)
        contentView.addSubview(stackView)
        stackView.pinToSuperview(edges: [.top], insets: layout.stackViewInsets)
        stackView.pinToSuperview(edges: [.left,.right], insets: layout.stackViewInsets)
        stackView.spacing = layout.stackViewSpacing
    }
    
}
