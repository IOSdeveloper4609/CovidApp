//
//  CustomCell.swift
//  COVIDPoint
//
//  Created by Азат Киракосян on 11.11.2021.
//

import UIKit

protocol OpenDetailedInfoProtocol: AnyObject {
    func openDetailedInfo(indexPath: IndexPath)
}

protocol HiddenDetailedInfoProtocol: AnyObject {
    func hiddenDetailedInfo(indexPath: IndexPath)
}

extension ListCell {
    struct Layout {
        let containerForUIInsets: UIEdgeInsets
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
        
        init(containerForUIInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0),
             stackViewInsets: UIEdgeInsets = .init(top: 40, left: 15, bottom: 50, right: 15),
             stackViewSpacing: CGFloat = 20,
             removeInfoButtonInsets: UIEdgeInsets = .init(top: 5, left: 0, bottom: 0, right: 10),
             removeInfoButtonSize: CGSize = .init(width: 20, height: 20),
             containerForButtonInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 12, right: 10),
             containerForButtonSize: CGSize = .init(width: 175, height: 40),
             imageButtonInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 20),
             imageButtonSize: CGSize = .init(width: 20, height: 30),
             detailedInfoButtonInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 40),
             detailedInfoButtonSize: CGSize = .init(width: 100, height: 30)) {
            self.containerForUIInsets = containerForUIInsets
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


final class ListCell: UICollectionViewCell {
    
    static var identifier = "ListCell"
    
    var cellIndexPath = IndexPath()
    weak var openInfoDelegate: OpenDetailedInfoProtocol?
    weak var hiddenInfoDelegate: HiddenDetailedInfoProtocol?

    private let appearances = Appearance()
    private var stackView = UIStackView()
    private let imageButton = UIImageView()
    private let detailedInfoButton = UIButton()
    private let removeInfoButton = UIButton()
    private let countryName = CountryNameView()
    private let progressConfirmed = ProgressView()
    private let progressDeaths = ProgressView()
    private let progressRecovered = ProgressView()
    private let containerForButton = UIView()
    private let containerForUI = UIView()
    private let boxView = UIView()
    
   weak var viewModel: ListCellViewModelProtocol? {
        didSet {
            guard let _viewModel = viewModel else { return }
            _viewModel.countryNameView = countryName
            _viewModel.progressConfirmed = progressConfirmed
            _viewModel.progressDeaths = progressDeaths
            _viewModel.progressRecovered = progressRecovered
            _viewModel.setData()
            _viewModel.setProgressData()

            self.containerForButton.isHidden = _viewModel.isSelected ? true : false
            self.removeInfoButton.isHidden = _viewModel.isSelected ? false : true
            self.progressDeaths.isHidden = _viewModel.isSelected ? false : true
            self.progressRecovered.isHidden = _viewModel.isSelected ? false : true
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
    
        setupProgressViewColors()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.countryNameView = nil
        viewModel?.progressConfirmed = nil
        viewModel?.progressDeaths = nil
        viewModel?.progressRecovered = nil
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
        boxView.translatesAutoresizingMaskIntoConstraints = false
        boxView.backgroundColor = .clear
        self.addSubview(boxView)
        boxView.pinToSuperview(edges: [.all],
                                      insets: layout.containerForUIInsets,
                                      safeArea: false,
                                      priority: .required)
        
        /// контейнер для UI
        containerForUI.translatesAutoresizingMaskIntoConstraints = false
        containerForUI.backgroundColor = .white
        containerForUI.layer.cornerRadius = 20
        containerForUI.clipsToBounds = true
        boxView.addSubview(containerForUI)
        containerForUI.pinToSuperview(edges: [.all],
                                      insets: layout.containerForUIInsets,
                                      safeArea: false,
                                      priority: .required)
        
        /// настройка кнопки скрытия инфы
        removeInfoButton.translatesAutoresizingMaskIntoConstraints = false
        removeInfoButton.setTitleColor(.black, for: .normal)
        removeInfoButton.setImage(UIImage(named: appearances.removeInfoButtonIcon), for: .normal)
        removeInfoButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        removeInfoButton.alpha = 0.5
        removeInfoButton.addTarget(self, action: #selector(hiddenDetailedInfo), for: .touchUpInside)
        containerForUI.addSubview(removeInfoButton)
        removeInfoButton.isHidden = true
        removeInfoButton.pin(size: layout.removeInfoButtonSize)
        removeInfoButton.pinToSuperview(edges: [.right, .top],
                                        insets: layout.removeInfoButtonInsets,
                                        safeArea: false,
                                        priority: .required)
        
        /// настройка stackView
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(countryName)
        stackView.addArrangedSubview(progressConfirmed)
        stackView.addArrangedSubview(progressDeaths)
        stackView.addArrangedSubview(progressRecovered)
        containerForUI.addSubview(stackView)
        stackView.spacing = layout.stackViewSpacing
        stackView.pinToSuperview(edges: [.top, .left, .right],
                                 insets: layout.stackViewInsets)
        
        /// настройка контейнера для кнопки и картинки
        containerForButton.translatesAutoresizingMaskIntoConstraints = false
        containerForUI.addSubview(containerForButton)
        containerForButton.pin(size: layout.containerForButtonSize)
        containerForButton.pinToSuperview(edges: [.right, .bottom],
                                          insets: layout.containerForButtonInsets,
                                          safeArea: false,
                                          priority: .required)
        
        /// настройка картинки на кнопке
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.image = UIImage(named: appearances.detailedInfoButtonIcon)
        containerForButton.addSubview(imageButton)
        imageButton.pin(size: layout.imageButtonSize)
        imageButton.pinToSuperview(edges: [.right, .bottom],
                                   insets: layout.imageButtonInsets,
                                   safeArea: false,
                                   priority: .required)
        
        /// настройка кнопки подробнее
        detailedInfoButton.translatesAutoresizingMaskIntoConstraints = false
        detailedInfoButton.setTitleColor(.black, for: .normal)
        detailedInfoButton.setTitle("Подробнее", for: .normal)
        detailedInfoButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        detailedInfoButton.alpha = 0.5
        detailedInfoButton.addTarget(self, action: #selector(openDetailedInfo), for: .touchUpInside)
        containerForButton.addSubview(detailedInfoButton)
        detailedInfoButton.pin(size: layout.detailedInfoButtonSize)
        detailedInfoButton.pinToSuperview(edges: [.right, .bottom],
                                          insets: layout.detailedInfoButtonInsets,
                                          safeArea: false,
                                          priority: .required)
    }
    
    @objc func openDetailedInfo() {
        if let openInfoDelegate = self.openInfoDelegate {
            openInfoDelegate.openDetailedInfo(indexPath: cellIndexPath)
        }
    }

    @objc func hiddenDetailedInfo() {
        if let hiddenInfoDelegate = self.hiddenInfoDelegate {
            hiddenInfoDelegate.hiddenDetailedInfo(indexPath: cellIndexPath)
        }
    }
}


