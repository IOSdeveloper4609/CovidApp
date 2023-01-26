//
//  GoogleMapViewModel.swift
//  apicovidtest
//
//  Created by Azat Kirakosyan on 19.10.2021.
//

import UIKit
import ReactiveKit
import CoreLocation
import MapKit

protocol MapViewModelProtocol {
    var result: PassthroughSubject<[MapViewModel.CountryState?], Never> { get }
    func getCountries()
    func getCountryState()
    var circleDistance: CLLocationDistance { get }
    var latitudeDelta: CLLocationDegrees { get }
    var containerForLabelPointCornerRadius: CGFloat { get }
    var confirmedLabelSize: CGFloat { get }
    var circleRendererAlpha: CGFloat { get }
    var defaultValue: Float { get }
    var containerForButtonsCornerRadius: CGFloat { get }
    var valueCameraMap: Double { get }
    var minCamera: Double { get }
    var maxCamera: Double { get }
}

extension MapViewModel {
    struct CountryState {
        let id: Int
        var lat: Float?
        var lon: Float?
        var confirmed: Int?
    }
}

final class MapViewModel: MapViewModelProtocol {
    let circleDistance: CLLocationDistance = 100000
    let latitudeDelta: CLLocationDegrees = 20
    let containerForLabelPointCornerRadius: CGFloat = 8
    let confirmedLabelSize: CGFloat = 11
    let circleRendererAlpha: CGFloat = 0.6
    let defaultValue: Float = 0.0
    let containerForButtonsCornerRadius: CGFloat = 10
    let valueCameraMap = 1.5
    let minCamera: Double = 1500000
    let maxCamera: Double = 10000000
    var result = PassthroughSubject<[CountryState?], Never>()
    let networkManager = NetworkManager()
    var countries: Countries?
    var countryState = [CountryState]() {
        didSet {
            self.result.send(self.countryState)
        }
    }
    
    private var localSessionManager: LocalSessionManagerProtocol?
    
    init(localSessionManager: LocalSessionManagerProtocol?) {
        self.localSessionManager = localSessionManager
    }
    
    func getCountries() {
        self.countries = localSessionManager?.covidData
        self.getCountryState()
    }
    
    func getCountryState() {
        var tmpCountryState = [CountryState]()
        countries?.data?.enumerated().forEach { (index, data) in
            var country = CountryState(id: index)
            country.lat = data.coordinates?.latitude
            country.lon = data.coordinates?.longitude
            country.confirmed = data.latestData.deaths
            tmpCountryState.append(country)
        }
        self.countryState = tmpCountryState
    }
}
