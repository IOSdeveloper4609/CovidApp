
import UIKit
import ReactiveKit

protocol SplashViewModelProtocol {
    var upload: PassthroughSubject<Bool, Never> { get }
    func getCountryInfo()
}

final class SplashViewModel: SplashViewModelProtocol {
    var upload = PassthroughSubject<Bool, Never>()
    
    private var requestManager: SplashRequestManagerProtocol?
    
    init(requestManager: SplashRequestManagerProtocol?) {
        self.requestManager = requestManager
    }
    
    func getCountryInfo() {
        if let _requestManager = self.requestManager {
            _requestManager.getCountryInfo { [weak self] (_, _) in
                guard let _self = self else { return }
                _self.upload.send(true)
            }
        }
    }
}
