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
        let segmentControlContainerSize: CGSize
        let segmentControlInsets: UIEdgeInsets
        let segmentControlSize: CGSize
        let collectionViewInsets: UIEdgeInsets
        
        init(segmentControlContainerInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0),
             segmentControlContainerSize: CGSize = .init(width: 0, height: 124),
             segmentControlInsets: UIEdgeInsets = .init(top: 65, left: 100, bottom: 0, right: 100),
             segmentControlSize: CGSize = .init(width: 200, height: 38),
             collectionViewInsets:  UIEdgeInsets = .init(top: 120, left: 0, bottom: 0, right: 0)) {
            self.segmentControlContainerInsets = segmentControlContainerInsets
            self.segmentControlContainerSize = segmentControlContainerSize
            self.segmentControlInsets = segmentControlInsets
            self.segmentControlSize = segmentControlSize
            self.collectionViewInsets = collectionViewInsets
        }
    }
    
    /// Appearance
    struct Appearance: AppearanceProtocol {
        let mapImage: String
        let listImage: String
        
        init(mapImage: String = "map",
             listImage: String = "list") {
            self.mapImage = mapImage
            self.listImage = listImage
        }
    }
    
    /// State
    enum State {
        
    }
}

// MARK: ListScreenViewController
/// Статистика по странам в виде списка
class ListScreenViewController: UIViewController {
    private var segmentControlContainer: UIView!
    private var segmentControl = UISegmentedControl()
    private var mainCollectionView: UICollectionView?
 
    let data = LocalSessionManager.shared.covidData?.data
    
    /// Layout
    private var layout: ListScreenViewController.Layout!
    /// Appearance
    private var appearance: ListScreenViewController.Appearance!
    
//    var viewModel: ListCellViewModelProtocol? {
//        didSet {
//            guard let _viewModel = self.viewModel else { return }
//            self.collectionView.reloadData()
//        }
//    }
    
    
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
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        self.mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        guard let mainCollectionView = mainCollectionView else { return }
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.isPagingEnabled = false
        mainCollectionView.backgroundColor = .white
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        self.view.addSubview(mainCollectionView)
        mainCollectionView.pinToSuperview(edges: [.all],
                                          insets: layout.collectionViewInsets,
                                          safeArea: false,
                                          priority: .required)
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
        let segmentImage: [UIImage?] = [UIImage(named: appearance.mapImage),
                                        UIImage(named: appearance.listImage)]
        
        self.segmentControl = UISegmentedControl(items: segmentImage as [Any])
        self.segmentControl.selectedSegmentIndex = 1
        self.segmentControl.translatesAutoresizingMaskIntoConstraints = false
        self.segmentControlContainer.addSubview(self.segmentControl)
        self.segmentControl.pinToSuperview(edges: [.top, .left, .right],
                                           insets: layout.segmentControlInsets,
                                           safeArea: false,
                                           priority: .required)
        self.segmentControl.pin(size: layout.segmentControlSize)
        self.segmentControl.addTarget(self, action: #selector(openMapViewController), for: .valueChanged)
    }
    
    @objc func openMapViewController() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let vm = MapViewModel(localSessionManager: LocalSessionManager.shared)
            let listScreen = MapViewController(viewModel: vm)
            listScreen.modalPresentationStyle = .fullScreen
            self.present(listScreen, animated: true, completion: nil)
        default:
            print("selectedSegmentIndex")
        }
    }
    
    
    /// Применение стилей
    private func apply(_ appearance: ListScreenViewController.Appearance) {
        self.segmentControlContainer.apply(style: appearance.translucentBackgroundStyle)
        self.segmentControl.apply(style: appearance.screenChangeControlStyle)
    }
}

extension ListScreenViewController: UICollectionViewDelegateFlowLayout,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            return UICollectionViewCell()
        }
         
        if let result = data?[safe: indexPath.row] {
            cell.setupWithModel(data: result)
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.indexPathsForSelectedItems?.first {
        case .some(indexPath):
            let height = (view.frame.width) * 2 / 20
            return CGSize(width: view.frame.width - 20, height: height + 300)
        default:
            let height = (view.frame.width) * 2 / 20
            return CGSize(width: view.frame.width - 50, height: height + 450)
        }
    }
    
}
