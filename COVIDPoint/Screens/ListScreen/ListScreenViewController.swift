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
        let cellLayout: ListCell.Layout
        
        init(segmentControlContainerInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0),
             segmentControlContainerSize: CGSize = .init(width: 0, height: 110),
             segmentControlInsets: UIEdgeInsets = .init(top: 65, left: 88, bottom: 0, right: 88),
             segmentControlSize: CGSize = .init(width: 200, height: 38),
             collectionViewInsets: UIEdgeInsets = .init(top: 120, left: 0, bottom: 0, right: 0),
             cellLayout: ListCell.Layout = .init()) {
            self.segmentControlContainerInsets = segmentControlContainerInsets
            self.segmentControlContainerSize = segmentControlContainerSize
            self.segmentControlInsets = segmentControlInsets
            self.segmentControlSize = segmentControlSize
            self.collectionViewInsets = collectionViewInsets
            self.cellLayout = cellLayout
        }
    }
    
    /// Appearance
    struct Appearance: AppearanceProtocol {
        let mapImage: String
        let listImage: String
        let containerSegmentControlBackground: UIColor
        
        init(mapImage: String = "map",
             listImage: String = "list",
             containerSegmentControlBackground: UIColor = UIColor(red: 236.0 / 255.0, green: 236.0 / 255.0, blue: 237.0 / 255.0, alpha: 1)) {
            self.mapImage = mapImage
            self.listImage = listImage
            self.containerSegmentControlBackground = containerSegmentControlBackground
        }
    }
}

// MARK: ListScreenViewController
class ListScreenViewController: UIViewController {
    private var segmentControlContainer: UIView!
    private var segmentControl: UISegmentedControl!
    private var mainCollectionView: UICollectionView!
    
    /// Layout
    private var layout: ListScreenViewController.Layout!
    /// Appearance
    private var appearance: ListScreenViewController.Appearance!
    /// Вьюмодель
    var viewModel: ListScreenViewModelProtocol!
    
    /// Инициализатор
    /// - Parameters:
    ///   - layout: ListScreenViewController.Layout
    ///   - appearance: ListScreenViewController.Appearance
    ///   - viewModel: ListScreenViewModelProtocol
    init(layout: ListScreenViewController.Layout,
         appearance: ListScreenViewController.Appearance,
         viewModel: ListScreenViewModelProtocol ) {
        self.layout = layout
        self.appearance = appearance
        self.viewModel = viewModel
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.segmentControl.selectedSegmentIndex = 1
    }
    
    /// Инициализация и настройка отступов UI элементов
    private func addAndSetupSubviews(layout: ListScreenViewController.Layout) {
        view.backgroundColor = appearance.containerSegmentControlBackground
        /// Настройка CollectionView
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        self.mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        guard let mainCollectionView = mainCollectionView else { return }
        mainCollectionView.showsVerticalScrollIndicator = true
        mainCollectionView.backgroundColor = appearance.containerSegmentControlBackground
        mainCollectionView.isPagingEnabled = false
        mainCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right:0 )
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
        self.segmentControlContainer.backgroundColor = appearance.containerSegmentControlBackground
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
        self.segmentControl.pin(size: layout.segmentControlSize)
        self.segmentControl.pinToSuperview(edges: [.top],
                                           insets: layout.segmentControlInsets,
                                           safeArea: false,
                                           priority: .required)
        self.segmentControl.pinCenterToSuperview(of: .horizontal)
        self.segmentControl.addTarget(self, action: #selector(openMapViewController), for: .valueChanged)
    }
    
    @objc func openMapViewController() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.tabBarController?.selectedIndex = 0
        
        default:
            print("selectedSegmentIndex")
        }
    }
    
    /// Применение стилей
    private func apply(_ appearance: ListScreenViewController.Appearance) {
        self.segmentControl.apply(style: appearance.screenChangeControlStyle)
    }
}

extension ListScreenViewController: UICollectionViewDelegateFlowLayout,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            assertionFailure("this cell is missing")
            return UICollectionViewCell()
        }
        cell.cellIndexPath = indexPath
        cell.openInfoDelegate = self
        cell.hiddenInfoDelegate = self
        cell.layout = self.layout.cellLayout
        cell.viewModel = self.viewModel.makeCellViewModel(indexPath.row)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellState = viewModel.cellState(index: indexPath.row)

        switch cellState {
        case .expandedHeight:
            return CGSize(width: mainCollectionView.frame.size.width - 18, height: viewModel.expandedHeight)
        case .notExpandedHeight:
            return CGSize(width: mainCollectionView.frame.size.width - 52, height: viewModel.notExpandedHeight)
        }
    }
}

extension ListScreenViewController: OpenDetailedInfoProtocol {
    func openDetailedInfo(indexPath: IndexPath) {
        viewModel.selectItem(atIndex: indexPath.row)

            viewModel.performCellAnimate { [weak self] in
            self?.mainCollectionView.reloadItems(at: [indexPath])
        }
    }
}

extension ListScreenViewController: HiddenDetailedInfoProtocol {
    func hiddenDetailedInfo(indexPath: IndexPath) {
        viewModel.valueArray[indexPath.row] = false

        viewModel.performCellAnimate { [weak self] in
            self?.mainCollectionView.reloadItems(at: [indexPath])
        }
    }
}
