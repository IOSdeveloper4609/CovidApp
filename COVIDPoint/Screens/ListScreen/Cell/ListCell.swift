//
//  CustomCell.swift
//  COVIDPoint
//
//  Created by usermac on 11.11.2021.
//

import UIKit

protocol DetailedInfoProtocol {
    func openDetailedInfo(cell: ListCell)
}


extension ListCell {
    struct Layout {
        var stackViewInsets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 20)
        var stackViewSpacing: CGFloat = 14
    }
    
    struct Appearance: AppearanceProtocol {
        let progressConfirmedStartColor: UIColor = UIColor.gray
        let progressConfirmedEndColor: UIColor = UIColor.darkGray
        
        let progressDeathsStartColor: UIColor = UIColor.darkRed
        let progressDeathsEndColor: UIColor = UIColor.lightRed
        
        let progressRecoveredStartColor: UIColor = UIColor.darkGreen
        let progressRecoveredEndColor: UIColor = UIColor.lightGreen
    }
}

final class ListCell: BaseCell {
    private let layout = Layout()
    private let appearances = Appearance()
    private let countryName = CountryNameView()
    private var progressConfirmed = ProgressView()
    private var stackView = UIStackView()
    private let detailedButton = UIButton()
    private let imageButton = UIImageView()
    var delegate: DetailedInfoProtocol?
    let progressDeaths = ProgressView()
    let progressRecovered = ProgressView()
    let histogramView = HistogramView()
  //  var flag: Bool = false
    
    var viewModel: ListCellViewModelProtocol? {
        didSet {
            guard var _viewModel = viewModel else { return }
            _viewModel.countryNameView = countryName
            _viewModel.progressConfirmed = progressConfirmed
            _viewModel.progressDeaths = progressDeaths
            _viewModel.progressRecovered = progressRecovered
            _viewModel.histogramView = histogramView
            _viewModel.setData()
            _viewModel.setProgressData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        progressDeaths.isHidden = true
//        progressRecovered.isHidden = true
//        histogramView.isHidden = true
        
        setupCell()
        addAndSetupSubviews(layout: layout)
        setupProgressViewColors()
    }
    
    override func prepareForReuse() {
        viewModel?.countryNameView = nil
        viewModel?.progressConfirmed = nil
        viewModel?.progressDeaths = nil
        viewModel?.progressRecovered = nil
        viewModel?.histogramView = nil
    }
    
    func setupProgressViewColors() {
        progressConfirmed.setProgressGradientColor([
            appearances.progressConfirmedStartColor,
            appearances.progressConfirmedEndColor
        ])
        
        progressDeaths.setProgressGradientColor([
            appearances.progressDeathsStartColor,
            appearances.progressDeathsEndColor
        ])
        
        progressRecovered.setProgressGradientColor([
            appearances.progressRecoveredStartColor,
            appearances.progressRecoveredEndColor
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAndSetupSubviews(layout: ListCell.Layout) {
        /// настройка stackView
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(countryName)
        stackView.addArrangedSubview(progressConfirmed)
//        stackView.addArrangedSubview(progressDeaths)
//        stackView.addArrangedSubview(progressRecovered)
//        stackView.addArrangedSubview(histogramView)
        contentView.addSubview(stackView)
        stackView.pinToSuperview(edges: [.top], insets: layout.stackViewInsets)
        stackView.pinToSuperview(edges: [.left,.right], insets: layout.stackViewInsets)
        stackView.spacing = layout.stackViewSpacing
        
        /// настройка контейнера для кнопки и картинки
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        NSLayoutConstraint.activate([
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            container.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            container.heightAnchor.constraint(equalToConstant: 35),
            container.widthAnchor.constraint(equalToConstant: 175)
        ])
        
        /// настройка картинки на кнопке
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.image = UIImage(named: "detailedButton")
        container.addSubview(imageButton)
        NSLayoutConstraint.activate([
            imageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            imageButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            imageButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        /// настройка кнопки подробнее
        detailedButton.translatesAutoresizingMaskIntoConstraints = false
        detailedButton.setTitleColor(.black, for: .normal)
        detailedButton.setTitle("подробнее", for: .normal)
        detailedButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        detailedButton.alpha = 0.5
        detailedButton.addTarget(self, action: #selector(openDetailedInfo), for: .touchUpInside)
        container.addSubview(detailedButton)
        NSLayoutConstraint.activate([
            detailedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            detailedButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -60),
            detailedButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func openDetailedInfo() {
        delegate?.openDetailedInfo(cell: self)
    }
}


