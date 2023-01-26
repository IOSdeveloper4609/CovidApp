
import UIKit
import ReactiveKit

protocol SplashViewModelProtocol {
    var upload: PassthroughSubject<Bool, Never> { get }
    func getCountryInfo()
}

final class SplashViewModel: SplashViewModelProtocol {
    
    var upload = PassthroughSubject<Bool, Never>()
    
    private var requestManager: SplashRequestManagerProtocol?
    private var localSessionManager: LocalSessionManagerProtocol?
    
    init(requestManager: SplashRequestManagerProtocol?,
         localSessionManager: LocalSessionManagerProtocol?) {
        self.requestManager = requestManager
        self.localSessionManager = localSessionManager
    }
    
    func getCountryInfo() {
        if let _requestManager = self.requestManager {
            _requestManager.getCountryInfo { [weak self] (data, error) in
                guard let _self = self else { return }
                _self.updateCovidData(data)
                _self.upload.send(true)
            }
        }
    }
    
    private func updateCovidData(_ covidData: Countries?) {
        if var _localSessionManager = self.localSessionManager {
            _localSessionManager.covidData = covidData
        }
    }
}
