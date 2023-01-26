import UIKit
import Alamofire

protocol SplashRequestManagerProtocol {
    func getCountryInfo(completion: @escaping (Countries?, NSError?) -> Void)
}

class SplashRequestManager: SplashRequestManagerProtocol {
    func getCountryInfo(completion: @escaping (Countries?, NSError?) -> Void) {
        let urlString = Constants.kBaseUrl + Constants.kCountries
        AF.request(urlString, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { results in
            switch results.result {
            case .success( _):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let object = try decoder.decode(Countries.self, from: results.data ?? Data())
                    completion(object, nil)
                    
                } catch let error as NSError {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error as NSError)
            }
        })
    }
}
