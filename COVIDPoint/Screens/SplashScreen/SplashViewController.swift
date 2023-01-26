import UIKit

// MARK: Layout & Appearance & State
extension SplashViewController {
    /// Layout
    struct Layout {
        let imageInsets: UIEdgeInsets
        let companyLogoImageSize: CGSize
        let companyLogoImageInsets: UIEdgeInsets
        
        init(imageInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0),
             companyLogoImageSize: CGSize = .init(width: 55, height: 56),
             companyLogoImageInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 100, right: 0) ) {
            self.imageInsets = imageInsets
            self.companyLogoImageSize = companyLogoImageSize
            self.companyLogoImageInsets = companyLogoImageInsets
        }
    }
    
    /// Appearance
    struct Appearance: AppearanceProtocol {
        let splashScreenImage: String
        let companyLogoImage: String
        
        init(splashScreenImage: String = "COVIPAppSplashLogo",
             companyLogoImage: String = "CompanyLogo") {
            self.splashScreenImage = splashScreenImage
            self.companyLogoImage = companyLogoImage
        }
    }
}

final class SplashViewController: UIViewController {
    private let layout: Layout = Layout()
    private let appearance: Appearance = Appearance()
    private var viewModel: SplashViewModelProtocol!
    private let splashScreenImage = UIImageView()
    private let companyLogoImage = UIImageView()
    private var window: UIWindow?
    
    /// Инициализатор
    /// - Parameter viewModel: SplashViewModelProtocol
    init(viewModel: SplashViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Инициализатор
    /// - Parameter coder: NSCoder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        viewModel.getCountryInfo()
        setupSplashScreenImage()
        setupCompanyLogoImage()
        setupObserve()
    }
    
    func setupTabBar() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .blue
        /// UITabBarController
        let tabBarController = UITabBarController()
        /// Статистика представленная на карте
        let mapScreen = MapViewController(viewModel: MapViewModel(localSessionManager: LocalSessionManager.shared))
        /// Статистика представленная в виде списка
        let listScreen = ListScreenViewController(layout: .init(), appearance: .init())
        /// Формирование массива рутовых экранов
        let viewControllers = [mapScreen, listScreen]
        /// Установка контроллеров
        tabBarController.setViewControllers(viewControllers, animated: true)
        /// Скрытие TabBar на экране
        tabBarController.tabBar.isHidden = false
        self.window?.rootViewController = tabBarController
    }
    
    func setupCompanyLogoImage() {
        companyLogoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(companyLogoImage)
        companyLogoImage.image = UIImage(named: appearance.companyLogoImage)
        companyLogoImage.pinCenterToSuperview(of: .horizontal)
        companyLogoImage.pin(size: layout.companyLogoImageSize)
        companyLogoImage.pinToSuperview(edges: [.bottom],
                                        insets: layout.companyLogoImageInsets,
                                        safeArea: false,
                                        priority: .required)
    }
    
    func setupSplashScreenImage() {
        splashScreenImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashScreenImage)
        splashScreenImage.image = UIImage(named: appearance.splashScreenImage)
        splashScreenImage.pinCenterToSuperview(of: .horizontal)
        splashScreenImage.pinCenterToSuperview(of: .vertical)
    }
    
    private func setupObserve() {
        _ = self.viewModel.upload.observeNext(with: { value in
            if value {
                let vm = MapViewModel(localSessionManager: LocalSessionManager.shared)
                let mapVC = MapViewController(viewModel: vm)
                mapVC.modalPresentationStyle = .fullScreen
                self.show(mapVC, sender: nil)
            }
        })
    }
}
