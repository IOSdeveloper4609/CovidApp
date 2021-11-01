//
//  ViewController.swift
//  apicovidtest
//
//  Created by Ahtem Sitjalilov on 18.10.2021.
//

import UIKit
import MapKit
import ReactiveKit

extension MapViewController {
    /// Отступы
    struct Layout {
        
        /// Отступы карты
        let mapInsets: UIEdgeInsets
        
        /// Инициализатор
        init(mapInsets: UIEdgeInsets = UIEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) {
            self.mapInsets = mapInsets
        }
    }
    
    
    // Внешний вид
    struct Appearance: AppearanceProtocol {
        let annotationImage: String
        let reuseId: String
        
        init(annotationImage: String = "pin",
             reuseId: String = "pin") {
            self.reuseId = reuseId
            self.annotationImage = annotationImage
        }
    }
}

final class MapViewController: UIViewController {
    
    private var layout = Layout()
    private var appearance = Appearance()
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private let viewModel = MapViewModel()
    private var circle = MKCircle()
    private let zoomButton = UIButton()
    private var zoom: Float = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupLocationManager()
        viewModel.prepareData()
        setupBinding()
        setupZoomButton()
        
    }
    
    func showCircle(coordinate: CLLocationCoordinate2D,
                    radius: CLLocationDistance) {
        let circle = MKCircle(center: coordinate,
                              radius: radius)
        mapView.addOverlay(circle)
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
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.isZoomEnabled = true
        view.addSubview(mapView)
        self.mapView.pinToSuperview(edges: [.left, .top , .right, .bottom],
                                    insets: layout.mapInsets,
                                    safeArea: false,
                                    priority: .required)
        
    }
    
    func setupZoomButton() {
        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        zoomButton.setImage(#imageLiteral(resourceName: "Zoom Controls"), for: .normal)
        mapView.addSubview(zoomButton)
        zoomButton.pin(size: CGSize(width: 25, height: 30))
        zoomButton.pinToSuperview(edges: [.top ,.right], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
        zoomButton.pinCenterToSuperview(of: .vertical)
    }
    
    
    
    func setupBinding() {
        self.viewModel.result.observeNext { [weak self] result in
            guard let _self = self else { return }
            
            var annotations: [MKAnnotation] = []
            result.forEach { data in
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(data?.lat ?? 0.0),
                                                               longitude: CLLocationDegrees(data?.lon ?? 0.0))
                
                _self.showCircle(coordinate: CLLocationCoordinate2D(
                                    latitude: CLLocationDegrees(data?.lat ?? 0.0),
                                    longitude: CLLocationDegrees(data?.lon ?? 0.0)), radius: 80000 as CLLocationDistance)
                
                annotations.append(annotation)
            }
            _self.mapView.addAnnotations(annotations)
            
        }.store(in: reactive.bag)
    }

    
    func requestLocation(location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
                
        
        let span = MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
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

            let reuseId = appearance.reuseId

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                let container = UIView()
                container.backgroundColor = .white
                annotationView?.addSubview(container)
                container.translatesAutoresizingMaskIntoConstraints = false
                container.pin(size: CGSize(width: 70, height: 30))
                container.pinToSuperview(edges: [.left,.bottom], insets: UIEdgeInsets(top: 0, left: -28, bottom: 20, right: 0))
                container.layer.masksToBounds = false
                container.layer.cornerRadius = 10

                let confirmedLabel = UILabel()
                confirmedLabel.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(confirmedLabel)
                confirmedLabel.pin(size: CGSize(width: 100, height: 30))
                confirmedLabel.pinToSuperview(edges: [.all], insets: UIEdgeInsets(top: 3, left: 7, bottom: 5, right: -3))
                confirmedLabel.text = "2324345" //String((viewModel.countryState.first?.confirmed) ?? 0)
                confirmedLabel.font = .boldSystemFont(ofSize: 11)
                confirmedLabel.textColor = .black
                annotationView?.image = UIImage(named: appearance.annotationImage)
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        var circleRenderer = MKCircleRenderer()
        if let overlay = overlay as? MKCircle {
            circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = #colorLiteral(red: 0.02352941176, green: 0.2823529412, blue: 0.6745098039, alpha: 0.7233487565)
            circleRenderer.alpha = 0.2
        }
        return circleRenderer
    }
    

}
