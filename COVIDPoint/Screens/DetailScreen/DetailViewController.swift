//
//  DetailViewController.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 26.10.2021.
//

import UIKit
import FittedSheets

extension DetailViewController {
    
    static func getSheetViewController() -> UIViewController {
        let vc = DetailViewController()
        let options = SheetOptions(
            pullBarHeight: 24,
            presentingViewCornerRadius: 20,
            shouldExtendBackground: true,
            setIntrinsicHeightOnNavigationControllers: true,
            useFullScreenMode: true,
            shrinkPresentingViewController: true,
            useInlineMode: false,
            horizontalPadding: 0,
            maxWidth: nil)
        
        let sheetController = SheetViewController(
            controller: vc,
            sizes: [],
            options: options)
        
        vc.sheetControll = sheetController
        
        sheetController.gripSize = CGSize(width: 50, height: 4)
        sheetController.gripColor = UIColor(hex: "#E6E6E6")
        sheetController.cornerRadius = 20
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = false
        sheetController.dismissOnOverlayTap = true
        sheetController.dismissOnPull = true
        sheetController.allowPullingPastMaxHeight = false
        sheetController.autoAdjustToKeyboard = true
        sheetController.animateIn(size: .fixed(200), duration: 2, completion: nil)
        return sheetController
    }
}

class DetailViewController: UIViewController {
    
    let viewModel = DetailViewModel()
    let layout = Layout()
    let appearances = Appearance()
    
    var stackView: UIStackView? = UIStackView()
    
    let countryName = CountryNameView()
    let progressConfirmed = ProgressView()
    let progressDeaths = ProgressView()
    let progressRecovered = ProgressView()
    let histogramView = HistogramView()
    
    weak var sheetControll: SheetViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupLayouts()
        setupAppearances()
        configure()
        viewModel.handleViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sheetControll?.setSizes([.fixed(550)], animated: true)
        viewModel.handleViewDidAppear()
    }
    
    func setupSubviews() {
        stackView = UIStackView()
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        stackView?.axis = .vertical
        stackView?.distribution = .fillProportionally
    }
    
    func setupLayouts() {
        view.addSubview(stackView!)
        stackView?.pinToSuperview(edges: [.top], insets: layout.stackViewInsets)
        stackView?.pinToSuperview(edges: [.left,.right], insets: layout.stackViewInsets)
        stackView?.spacing = layout.stackViewSpacing
    }
    
    func setupAppearances() {
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
    
    func configure() {
        
        viewModel.countryNameView = countryName
        stackView?.addArrangedSubview(countryName)
        
        viewModel.progressConfirmed = progressConfirmed
        stackView?.addArrangedSubview(progressConfirmed)
        
        viewModel.progressDeaths = progressDeaths
        stackView?.addArrangedSubview(progressDeaths)
        
        viewModel.progressRecovered = progressRecovered
        stackView?.addArrangedSubview(progressRecovered)
        
        viewModel.histogramView = histogramView
        stackView?.addArrangedSubview(histogramView)
    }
}
