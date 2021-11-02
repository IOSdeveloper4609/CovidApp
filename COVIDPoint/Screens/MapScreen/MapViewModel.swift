//
//  GoogleMapViewModel.swift
//  apicovidtest
//
//  Created by Ahtem Sitjalilov on 19.10.2021.
//

import UIKit
import ReactiveKit
import CoreLocation
import MapKit

protocol MapViewModelProtocol {
    var result: PassthroughSubject<[MapViewModel.CountryState?], Never> { get }
}

extension MapViewModel {
    struct CountryState {
        let id: Int
        var lat: Float?
        var lon: Float?
        var confirmed: Int?
        var pointColor: UIColor?
    }
}


final class MapViewModel:  MapViewModelProtocol {
    var result = PassthroughSubject<[CountryState?], Never>()
    let networkManager = NetworkManager()
    var countries: Countries?
    var countryState = [CountryState]() {
        didSet {
            self.result.send(self.countryState)
        }
    }

    func prepareData() {
        getCountries()
    }
    
    func getCountries() {
        networkManager.getCountryInfo { result in
            self.countries = result
            self.getCounryState()
        }
    }
    
    func getCounryState() {
        var tmpCountryState = [CountryState]()
        countries?.data?.enumerated().forEach { (index, data) in
            var country = CountryState(id: index)
            country.lat = data.coordinates?.latitude
            country.lon = data.coordinates?.longitude
            country.confirmed = data.latestData.deaths
            country.pointColor = nil
            tmpCountryState.append(country)
        }
        self.countryState = tmpCountryState
    }
}
