//
//  ListScreenViewController.swift
//  COVIDPoint
//
//  Created by user on 25.10.2021.
//

import UIKit

// MARK: Layout & Appearance & State
extension ListScreenViewController {
    /// Layout
    struct Layout {
        let segmentControlContainerInsets: UIEdgeInsets
        
        init(segmentControlContainerInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)) {
            self.segmentControlContainerInsets = segmentControlContainerInsets
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
    }
    
    /// Инициализация и настройка отступов UI элементов
    private func addAndSetupSubviews(layout: ListScreenViewController.Layout) {
        self.segmentControlContainer = UIView()
        self.segmentControlContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.segmentControlContainer)
        self.segmentControlContainer.pinToSuperview(edges: [.left, .top, .right],
                                                    insets: layout.segmentControlContainerInsets,
                                                    safeArea: false,
                                                    priority: .required)
    }
    
    /// Применение стилей
    private func apply(_ appearance: ListScreenViewController.Appearance) {
        
    }
}
