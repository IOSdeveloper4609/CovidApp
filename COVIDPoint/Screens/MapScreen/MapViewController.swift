//
//  ViewController.swift
//  apicovidtest
//
//  Created by Ahtem Sitjalilov on 18.10.2021.
//

import UIKit
import MapKit
import ReactiveKit

final class MapViewController: UIViewController {
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private let viewModel = MapViewModel()
    var circle = MKCircle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupLocationManager()
        viewModel.prepareData()
        setupBinding()
        
    }
    
    func createCircle(location: CLLocation) {

        circle = MKCircle(center: location.coordinate, radius: 500 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
}


private extension MapViewController {
   
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupBinding() {
        self.viewModel.result.observeNext { [weak self] result in
            guard let _self = self else { return }
            
            let annotations = result.compactMap { data -> MKAnnotation in
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(data?.lat ?? 0.0),
                                                               longitude: CLLocationDegrees(data?.lon ?? 0.0))
                
                
                return annotation
            }
            _self.mapView.addAnnotations(annotations)
            
        }.store(in: reactive.bag)
    }
    
    func requestLocation(location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Ваше местоположение"
        mapView.addAnnotation(pin)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            requestLocation(location: location)
        }
    }
}
    
extension MapViewController: MKMapViewDelegate {

        /// добавили кастомную картинку на точки в карте
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

            let reuseId = "pin"

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                annotationView?.image = UIImage(named: "pin")
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }

//        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//            if let lt = view.annotation?.coordinate.latitude, let lng = view.annotation?.coordinate.longitude {
//                let coordinate = CLLocationCoordinate2DMake(lt, lng)
//                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
//                let title = view.annotation?.title ?? ""
//                let subtitle = view.annotation?.subtitle ?? ""
//                mapItem.name = (title ?? "") + (subtitle ?? "")
//            }
//        }
    }

