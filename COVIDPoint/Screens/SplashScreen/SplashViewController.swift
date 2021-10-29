import UIKit

// MARK: Layout & Appearance & State
extension SplashViewController {
    /// Layout
    struct Layout {
        let imageInsets: UIEdgeInsets
        
        init(imageInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)) {
            self.imageInsets = imageInsets
        }
    }
    
    /// Appearance
    struct Appearance: AppearanceProtocol {
        
    }
}

final class SplashViewController: UIViewController {
    private let layout: Layout = Layout()
    private let appearance: Appearance = Appearance()
    private var viewModel: SplashViewModelProtocol!
    
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
        self.viewModel.getCountryInfo()
    }
    
    private func setupObserve() {
        _ = self.viewModel.upload.observeNext(with: { (value) in
            if value {
                /// To Do переход на экран
            }
        })
    }
}
