//
//  ListScreenViewController.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 25.10.2021.
//

import UIKit

// MARK: Layout & Appearance & State
extension ListScreenViewController {
    /// Layout
    struct Layout {
        let segmentControlContainerInsets: UIEdgeInsets
        let segmentControlContainerSize: CGSize
        let segmentControlInsets: UIEdgeInsets
        let segmentControlSize: CGSize
        
        init(segmentControlContainerInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0),
             segmentControlContainerSize: CGSize = .init(width: 0, height: 124),
             segmentControlInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 20, right: 0),
             segmentControlSize: CGSize = .init(width: 200, height: 38)) {
            self.segmentControlContainerInsets = segmentControlContainerInsets
            self.segmentControlContainerSize = segmentControlContainerSize
            self.segmentControlInsets = segmentControlInsets
            self.segmentControlSize = segmentControlSize
        }
    }
    
    /// Appearance
    struct Appearance: AppearanceProtocol {
        
    }
    
    /// State
    enum State {
        
    }
}

// MARK: ListScreenViewController
/// Статистика по странам в виде списка
class ListScreenViewController: UIViewController {
    private var segmentControlContainer: UIView!
    private var segmentControl: UISegmentedControl!
    private var collectionView: UICollectionView!
    
    
    /// Layout
    private var layout: ListScreenViewController.Layout!
    /// Appearance
    private var appearance: ListScreenViewController.Appearance!
    
    
    /// Инициализатор
    /// - Parameters:
    ///   - layout: ListScreenViewController.Layout
    ///   - appearance: ListScreenViewController.Appearance
    init(layout: ListScreenViewController.Layout,
         appearance: ListScreenViewController.Appearance) {
        self.layout = layout
        self.appearance = appearance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Second screen loaded")
    }
    
    override func loadView() {
        super.loadView()
        
        self.addAndSetupSubviews(layout: self.layout)
        self.apply(self.appearance)
    }
    
    /// Инициализация и настройка отступов UI элементов
    private func addAndSetupSubviews(layout: ListScreenViewController.Layout) {
        /// Настройка SegmentControlContainer
        self.segmentControlContainer = UIView()
        self.segmentControlContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.segmentControlContainer)
        self.segmentControlContainer.pinToSuperview(edges: [.left, .top, .right],
                                                    insets: layout.segmentControlContainerInsets,
                                                    safeArea: false,
                                                    priority: .required)
        self.segmentControlContainer.pin(height: layout.segmentControlContainerSize.height)
        /// Настройка SegmentControl
        self.segmentControl = UISegmentedControl()
        self.segmentControl.translatesAutoresizingMaskIntoConstraints = false
        self.segmentControlContainer.addSubview(self.segmentControl)
        self.segmentControl.pinToSuperview(edges: [.bottom],
                                           insets: layout.segmentControlInsets,
                                           safeArea: false,
                                           priority: .required)
        self.segmentControl.pin(size: layout.segmentControlSize)
    }
    
    /// Применение стилей
    private func apply(_ appearance: ListScreenViewController.Appearance) {
        self.segmentControlContainer.apply(style: appearance.translucentBackgroundStyle)
        self.segmentControl.apply(style: appearance.screenChangeControlStyle)
    }
}
