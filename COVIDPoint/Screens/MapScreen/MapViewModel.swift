//
//  MapViewModel.swift
//  COVIDPoint
//
//  Created by usermac on 30.11.2021.
//

import UIKit
import ReactiveKit
import CoreLocation
import MapKit

struct CountryState {
    let id: Int
    var lat: Double?
    var lon: Double?
    var confirmed: Int?
}

protocol MapViewModelProtocol {
    var result: PassthroughSubject<[CountryState?], Never> { get }
    func getCountries()
    func getCountryState()
    var circleDistance: CLLocationDistance { get }
    var latitudeDelta: CLLocationDegrees { get }
    var containerForLabelPointCornerRadius: CGFloat { get }
    var confirmedLabelSize: CGFloat { get }
    var circleRendererAlpha: CGFloat { get }
    var defaultValue: Double { get }
    var containerForButtonsCornerRadius: CGFloat { get }
    var valueCameraMap: Double { get }
    var minCamera: Double { get }
    var maxCamera: Double { get }
}

final class MapViewModel: MapViewModelProtocol {
    let circleDistance: CLLocationDistance = 50000
    let latitudeDelta: CLLocationDegrees = 0.1
    let containerForLabelPointCornerRadius: CGFloat = 6
    let confirmedLabelSize: CGFloat = 9
    let circleRendererAlpha: CGFloat = 0.6
    let defaultValue: Double = 0.0
    let containerForButtonsCornerRadius: CGFloat = 10
    let valueCameraMap = 1.5
    let minCamera: Double = 1000000
    let maxCamera: Double = 4000000
    var result = PassthroughSubject<[CountryState?], Never>()
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
        countries?.data?.enumerated().forEach { (index,data) in
            var country = CountryState(id: index)
            country.lat = data.coordinates?.latitude
            country.lon = data.coordinates?.longitude
            country.confirmed = data.latestData.confirmed
            tmpCountryState.append(country)
        }
        self.countryState = tmpCountryState
    }
}
