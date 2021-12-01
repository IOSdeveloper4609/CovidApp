//
//  CustomCell.swift
//  COVIDPoint
//
//  Created by usermac on 11.11.2021.
//

import UIKit

protocol OpenDetailedInfoProtocol {
    func openDetailedInfo(indexPath: IndexPath)
}

protocol HiddenDetailedInfoProtocol {
    func removeDetailedInfo(indexPath: IndexPath)
}

extension ListCell {
    struct Layout {
        let stackViewInsets: UIEdgeInsets
        let stackViewSpacing: CGFloat
        let removeInfoButtonInsets: UIEdgeInsets
        let removeInfoButtonSize: CGSize
        let containerForButtonInsets: UIEdgeInsets
        let containerForButtonSize: CGSize
        let imageButtonInsets: UIEdgeInsets
        let imageButtonSize: CGSize
        let detailedInfoButtonInsets: UIEdgeInsets
        let detailedInfoButtonSize: CGSize
        
        init(stackViewInsets: UIEdgeInsets = .init(top: 35, left: 15, bottom: 50, right: 15),
             stackViewSpacing: CGFloat = 20,
             removeInfoButtonInsets: UIEdgeInsets = .init(top: 10, left: 0, bottom: 0, right: 10),
             removeInfoButtonSize: CGSize = .init(width: 20, height: 20),
             containerForButtonInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 12, right: 10),
             containerForButtonSize: CGSize = .init(width: 175, height: 40),
             imageButtonInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 4, right: 23),
             imageButtonSize: CGSize = .init(width: 20, height: 30),
             detailedInfoButtonInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 4, right: 45),
             detailedInfoButtonSize: CGSize = .init(width: 100, height: 30)) {
            self.stackViewInsets = stackViewInsets
            self.stackViewSpacing = stackViewSpacing
            self.removeInfoButtonInsets = removeInfoButtonInsets
            self.removeInfoButtonSize = removeInfoButtonSize
            self.containerForButtonInsets = containerForButtonInsets
            self.containerForButtonSize = containerForButtonSize
            self.imageButtonInsets = imageButtonInsets
            self.imageButtonSize = imageButtonSize
            self.detailedInfoButtonInsets = detailedInfoButtonInsets
            self.detailedInfoButtonSize = detailedInfoButtonSize
        }
    }
}
    
    struct Appearance: AppearanceProtocol {
        let detailedInfoButtonIcon: String
        let removeInfoButtonIcon: String
        let progressConfirmedStartColor: UIColor
        let progressConfirmedEndColor: UIColor
        let progressDeathsStartColor: UIColor
        let progressDeathsEndColor: UIColor
        let progressRecoveredStartColor: UIColor
        let progressRecoveredEndColor: UIColor
        
        init(detailedInfoButtonIcon: String = "detailedButton",
             removeInfoButtonIcon: String = "removeButton",
             progressConfirmedStartColor: UIColor = .gray,
             progressConfirmedEndColor: UIColor = .darkGray,
             progressDeathsStartColor: UIColor = .darkRed,
             progressDeathsEndColor: UIColor = .lightRed,
             progressRecoveredStartColor: UIColor = .darkGreen,
             progressRecoveredEndColor: UIColor = .lightGreen) {
            self.detailedInfoButtonIcon = detailedInfoButtonIcon
            self.removeInfoButtonIcon = removeInfoButtonIcon
            self.progressConfirmedStartColor = progressConfirmedStartColor
            self.progressConfirmedEndColor = progressConfirmedEndColor
            self.progressDeathsStartColor = progressDeathsStartColor
            self.progressDeathsEndColor = progressDeathsEndColor
            self.progressRecoveredStartColor = progressRecoveredStartColor
            self.progressRecoveredEndColor = progressRecoveredEndColor
        }
    }


final class ListCell: BaseCell {
    var cellIndexPath = IndexPath()
    var openInfoDelegate: OpenDetailedInfoProtocol?
    var removeInfoDelegate: HiddenDetailedInfoProtocol?

    private let appearances = Appearance()
    private var stackView = UIStackView()
    private let imageButton = UIImageView()
    private let detailedInfoButton = UIButton()
    private let removeInfoButton = UIButton()
    private let countryName = CountryNameView()
    private var progressConfirmed = ProgressView()
    private let progressDeaths = ProgressView()
    private let progressRecovered = ProgressView()
    private let histogramView = HistogramView()
    private let containerForButton = UIView()
    
  
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
            
            self.containerForButton.isHidden = _viewModel.isSelected ? true : false
            self.removeInfoButton.isHidden = _viewModel.isSelected ? false : true
            self.progressDeaths.isHidden = _viewModel.isSelected ? false : true
            self.progressRecovered.isHidden = _viewModel.isSelected ? false : true
        //    self.histogramView.isHidden = _viewModel.isSelected ? false : true
        }
    }
    
    /// Отступы и размеры
    var layout: Layout? {
        didSet {
            self.addAndSetupSubviews(layout: self.layout ?? Layout())
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupCell()
        setupProgressViewColors()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
        /// настройка кнопки скрытия инфы
        removeInfoButton.translatesAutoresizingMaskIntoConstraints = false
        removeInfoButton.setTitleColor(.black, for: .normal)
        removeInfoButton.setImage(UIImage(named: appearances.removeInfoButtonIcon), for: .normal)
        removeInfoButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        removeInfoButton.alpha = 0.5
        removeInfoButton.addTarget(self, action: #selector(removeDetailedInfo), for: .touchUpInside)
        contentView.addSubview(removeInfoButton)
        removeInfoButton.isHidden = true
        removeInfoButton.pinToSuperview(edges: [.right, .top],
                                        insets: layout.removeInfoButtonInsets,
                                        safeArea: false, priority: .required)
        removeInfoButton.pin(size: layout.removeInfoButtonSize)

        /// настройка stackView
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(countryName)
        stackView.addArrangedSubview(progressConfirmed)
        stackView.addArrangedSubview(progressDeaths)
        stackView.addArrangedSubview(progressRecovered)
     //   stackView.addArrangedSubview(histogramView)
        contentView.addSubview(stackView)
        stackView.pinToSuperview(edges: [.top, .left, .right], insets: layout.stackViewInsets)
        stackView.spacing = layout.stackViewSpacing
        
        /// настройка контейнера для кнопки и картинки
        containerForButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerForButton)
        containerForButton.pinToSuperview(edges: [.right, .bottom],
                                          insets: layout.containerForButtonInsets,
                                        safeArea: false, priority: .required)
        containerForButton.pin(size: layout.containerForButtonSize)

        /// настройка картинки на кнопке
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.image = UIImage(named: appearances.detailedInfoButtonIcon)
        containerForButton.addSubview(imageButton)
        imageButton.pinToSuperview(edges: [.right, .bottom],
                                   insets: layout.imageButtonInsets,
                                        safeArea: false, priority: .required)
        imageButton.pin(size: layout.imageButtonSize)
        
        /// настройка кнопки подробнее
        detailedInfoButton.translatesAutoresizingMaskIntoConstraints = false
        detailedInfoButton.setTitleColor(.black, for: .normal)
        detailedInfoButton.setTitle("подробнее", for: .normal)
        detailedInfoButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        detailedInfoButton.alpha = 0.5
        detailedInfoButton.addTarget(self, action: #selector(openDetailedInfo), for: .touchUpInside)
        containerForButton.addSubview(detailedInfoButton)
        detailedInfoButton.pinToSuperview(edges: [.right, .bottom],
                                          insets: layout.detailedInfoButtonInsets,
                                        safeArea: false, priority: .required)
        detailedInfoButton.pin(size: layout.detailedInfoButtonSize)
    }
    
    @objc func openDetailedInfo() {
        if let openInfoDelegate = self.openInfoDelegate {
            openInfoDelegate.openDetailedInfo(indexPath: cellIndexPath)
        }
    }
    
    @objc func removeDetailedInfo() {
        if let removeInfoDelegate = self.removeInfoDelegate {
            removeInfoDelegate.removeDetailedInfo(indexPath: cellIndexPath)
        }
    }
}


