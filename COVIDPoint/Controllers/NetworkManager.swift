//
//  Network.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 08.11.2021.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func getCountryInfo(completion: @escaping (Countries?, NSError?) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
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
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
            }
        })
    }
}

