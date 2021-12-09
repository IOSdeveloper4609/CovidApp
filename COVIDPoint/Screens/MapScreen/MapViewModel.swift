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
    var latitudeDelta: CLLocationDegrees { get }
    /// корнер радиус контейнера
    var containerForLabelPointCornerRadius: CGFloat { get }
    /// шрифт лэйбла зараженных
    var confirmedLabelSize: CGFloat { get }
    /// дефолтное значение при разворачивании опционала
    var defaultValue: Double { get }
    /// контейнер для кнопок отдаления и приближения карты
    var containerForButtonsCornerRadius: CGFloat { get }
    /// на сколько приближать и отдалять карту при нажатии
    var valueCameraMap: Double { get }
    /// минимальная камера карты
    var minCamera: Double { get }
    /// максимальная камера карты
    var maxCamera: Double { get }
    /// отдалить карту
    func makeMapSmaller(_ mapView: MKMapView)
    /// приблизить карту
    func makeMapBigger(_ mapView: MKMapView)
    /// настройка масштабирования карты
    func setupCameraZoomRange(_ mapView: MKMapView)
    /// запрос на местоположение
    func requestLocation(_ location: CLLocation, _ mapView: MKMapView)
    /// метод определния местоположения
    func setupLocationManager(_ locationManager: CLLocationManager)
    ///показать местоположение юзера по нажатию на кнопку
    func showUserLocation(_ locationManager: CLLocationManager)
}

final class MapViewModel: MapViewModelProtocol {
    let latitudeDelta: CLLocationDegrees = 0.1
    let containerForLabelPointCornerRadius: CGFloat = 6
    let confirmedLabelSize: CGFloat = 9
    let defaultValue: Double = 0.0
    let containerForButtonsCornerRadius: CGFloat = 10
    let valueCameraMap = 1.5
    let minCamera: Double = 400000
    let maxCamera: Double = 5500000
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
    
    func makeMapBigger(_ mapView: MKMapView) {
        let currentCamera = mapView.camera
        let newCamera: MKMapCamera
        if #available(iOS 9.0, *) {
            newCamera = MKMapCamera(lookingAtCenter: currentCamera.centerCoordinate,
                                    fromDistance: currentCamera.altitude / valueCameraMap,
                                    pitch: currentCamera.pitch,
                                    heading: currentCamera.heading)
        }
        else {
            newCamera = MKMapCamera()
            newCamera.centerCoordinate = currentCamera.centerCoordinate
            newCamera.heading = currentCamera.heading
            newCamera.altitude = currentCamera.altitude / valueCameraMap
            newCamera.pitch = currentCamera.pitch
        }
        mapView.setCamera(newCamera, animated: true)
    }
    
    func makeMapSmaller(_ mapView: MKMapView) {
        let currentCamera = mapView.camera
        let newCamera: MKMapCamera
        if #available(iOS 9.0, *) {
            newCamera = MKMapCamera(lookingAtCenter: currentCamera.centerCoordinate
                                    , fromDistance: currentCamera.altitude * valueCameraMap,
                                    pitch: currentCamera.pitch,
                                    heading: currentCamera.heading)
        } else {
            newCamera = MKMapCamera()
            newCamera.centerCoordinate = currentCamera.centerCoordinate
            newCamera.heading = currentCamera.heading
            newCamera.altitude = currentCamera.altitude * valueCameraMap
            newCamera.pitch = currentCamera.pitch
        }
        mapView.setCamera(newCamera, animated: true)
    }
    
    func setupCameraZoomRange(_ mapView: MKMapView) {
        if #available(iOS 13.0, *) {
            mapView.cameraZoomRange = MKMapView.CameraZoomRange(
                minCenterCoordinateDistance: minCamera,
                maxCenterCoordinateDistance: maxCamera)
        }
    }
    
    func requestLocation(_ location: CLLocation, _ mapView: MKMapView) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: latitudeDelta)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        // mapView.addAnnotation(pin)
    }
    
    func setupLocationManager(_ locationManager: CLLocationManager) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func showUserLocation(_ locationManager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}


