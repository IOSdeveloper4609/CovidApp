//
//  NetLayer.swift
//  apicovidtest
//
//  Created by Ahtem Sitjalilov on 19.10.2021.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    func getCountryInfo(completion: @escaping (Countries) -> Void) {
        let urlString = ProjectSetting.baseUrl.rawValue
        
        AF.request(urlString, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { results in
            
            switch results.result {
            case .success( _):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let object = try decoder.decode(Countries.self, from: results.data ?? Data())
                    completion(object)
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
            }
        })
    }
    
}
