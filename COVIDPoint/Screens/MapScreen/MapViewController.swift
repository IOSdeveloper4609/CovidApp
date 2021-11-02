//
//  ViewController.swift
//  apicovidtest
//
//  Created by Ahtem Sitjalilov on 18.10.2021.
//

import UIKit
import MapKit
import ReactiveKit
import Bond

private extension MapViewController {
    /// Отступы
    struct Layout {
        
        /// Отступы 
        let mapInsets: UIEdgeInsets
        let containerSize: CGSize
        let containerInsets: UIEdgeInsets
        let confirmedLabelSize: CGSize
        let confirmedLabelInsets: UIEdgeInsets
        let makeMapBiggerButtonSize: CGSize
        let makeMapBiggerButtonInsets: UIEdgeInsets
        let makeMapSmallerButtonSize: CGSize
        let makeMapSmallerButtonInsets: UIEdgeInsets
        let containerForButtonsSize: CGSize
        let containerForButtonsInsets: UIEdgeInsets
        let delimiterImageSize: CGSize
        let delimiterImageInsets: UIEdgeInsets
        
        /// Инициализатор
        init(mapInsets: UIEdgeInsets = UIEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
             containerSize: CGSize = CGSize(width: 70, height: 25),
             containerInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: -28, bottom: 20, right: 0),
             confirmedLabelSize: CGSize = CGSize(width: 100, height: 0),
             confirmedLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5),
             makeMapBiggerButtonSize: CGSize = CGSize(width: 35, height: 10),
             makeMapBiggerButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 13, left: 10, bottom: 52, right: 10),
             makeMapSmallerButtonSize: CGSize = CGSize(width: 35, height: 10),
             makeMapSmallerButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 55, left: 10, bottom: 10, right: 10),
             containerForButtonsSize: CGSize = CGSize(width: 41, height: 80),
             containerForButtonsInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 10),
             delimiterImageSize: CGSize = CGSize(width: 35, height: 1),
             delimiterImageInsets: UIEdgeInsets = UIEdgeInsets(top: 42, left: 5, bottom: 35, right: 5)  ) {
            self.mapInsets = mapInsets
            self.containerSize = containerSize
            self.containerInsets = containerInsets
            self.confirmedLabelSize = confirmedLabelSize
            self.confirmedLabelInsets = confirmedLabelInsets
            self.makeMapBiggerButtonSize = makeMapBiggerButtonSize
            self.makeMapBiggerButtonInsets = makeMapBiggerButtonInsets
            self.makeMapSmallerButtonSize = makeMapSmallerButtonSize
            self.makeMapSmallerButtonInsets = makeMapSmallerButtonInsets
            self.containerForButtonsSize = containerForButtonsSize
            self.containerForButtonsInsets = containerForButtonsInsets
            self.delimiterImageSize = delimiterImageSize
            self.delimiterImageInsets = delimiterImageInsets
        }
    }
    
    
    // Внешний вид
    struct Appearance: AppearanceProtocol {
        let annotationImage: String
        let reuseId: String
        let smallerImage: String
        let biggerImage: String
        let delimiterImage: String
        
        init(annotationImage: String = "pin",
             reuseId: String = "pin",
             smallerImage: String = "smaller",
             biggerImage: String = "bigger",
             delimiterImage: String = "delimiter") {
            self.reuseId = reuseId
            self.annotationImage = annotationImage
            self.smallerImage = smallerImage
            self.biggerImage = biggerImage
            self.delimiterImage = delimiterImage
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
    private let makeMapBiggerButton = UIButton()
    private let makeMapSmallerButton = UIButton()
    private let delimiterImage = UIImageView()
    private let circleDistance: CLLocationDistance = 100000
    private let latitudeDelta: CLLocationDegrees = 1
    private let containerForLabelPointCornerRadius: CGFloat = 8
    private let confirmedLabelSize: CGFloat = 11
    private let circleRendererAlpha: CGFloat = 0.6
    private let defaultValue: Float = 0.0
    private let containerForButtons = UIView()
    private let containerForButtonsCornerRadius: CGFloat = 10
    private let valueCameraMap = 1.5
    private let minCamera: Double = 1500000
    private let maxCamera: Double = 10000000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationManager()
        viewModel.prepareData()
        setupBinding()
        setupContainerForButtons()
        setupMakeMapBiggerButton()
        setupMakeMapSmallerButton()
        setupDelimiterImage()
        addObserves()
        setupCameraZoomRange()
    }
}

// MARK: - Private
private extension MapViewController {
    /// настройка locationManager
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /// настройка карты
    func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        view.addSubview(mapView)
        self.mapView.pinToSuperview(edges: [.all],
                                    insets: layout.mapInsets,
                                    safeArea: false,
                                    priority: .required)
    }
    
    /// настройка контейнера для кнопок
    func setupContainerForButtons() {
        containerForButtons.translatesAutoresizingMaskIntoConstraints = false
        containerForButtons.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mapView.addSubview(containerForButtons)
        containerForButtons.layer.cornerRadius = containerForButtonsCornerRadius
        containerForButtons.pin(size: layout.containerForButtonsSize)
        containerForButtons.pinToSuperview(edges: [.right],
                                           insets: layout.containerForButtonsInsets)
        containerForButtons.pinCenterToSuperview(of: .vertical)
    }
    
    /// настройка кнопки приближения карты
    func setupMakeMapBiggerButton() {
        makeMapBiggerButton.translatesAutoresizingMaskIntoConstraints = false
        makeMapBiggerButton.setImage(UIImage(named: appearance.biggerImage), for: .normal)
        containerForButtons.addSubview(makeMapBiggerButton)
        makeMapBiggerButton.contentMode = .scaleAspectFit
        makeMapBiggerButton.pin(size: layout.makeMapBiggerButtonSize)
        makeMapBiggerButton.pinToSuperview(edges: [.all],
                                           insets: layout.makeMapBiggerButtonInsets)
    }
    
    /// настройка кнопки отдаления карты
    func setupMakeMapSmallerButton() {
        makeMapSmallerButton.translatesAutoresizingMaskIntoConstraints = false
        makeMapSmallerButton.setImage(UIImage(named: appearance.smallerImage), for: .normal)
        containerForButtons.addSubview(makeMapSmallerButton)
        makeMapSmallerButton.contentMode = .scaleAspectFit
        makeMapSmallerButton.pin(size: layout.makeMapSmallerButtonSize)
        makeMapSmallerButton.pinToSuperview(edges: [.all],
                                            insets: layout.makeMapSmallerButtonInsets)
    }
    
    /// настройка картинки разделения кнопок
    func setupDelimiterImage() {
        delimiterImage.translatesAutoresizingMaskIntoConstraints = false
        delimiterImage.image = UIImage(named: appearance.delimiterImage)
        containerForButtons.addSubview(delimiterImage)
        delimiterImage.pin(size: layout.delimiterImageSize)
        delimiterImage.pinToSuperview(edges: [.all],
                                            insets: layout.delimiterImageInsets)
    }
    
    /// настройка  масштабирования карты
    func setupCameraZoomRange() {
        if #available(iOS 13.0, *) {
            mapView.cameraZoomRange = MKMapView.CameraZoomRange(
                minCenterCoordinateDistance: minCamera,
                maxCenterCoordinateDistance: maxCamera)
        }
    }
    
    /// Добавление обсерверов
    func addObserves() {
        makeMapBiggerButton.reactive.tap.observeNext {
            let currentCamera = self.mapView.camera
            let newCamera: MKMapCamera
            if #available(iOS 9.0, *) {
                newCamera = MKMapCamera(lookingAtCenter: currentCamera.centerCoordinate,
                                        fromDistance: currentCamera.altitude / self.valueCameraMap,
                                        pitch: currentCamera.pitch,
                                        heading: currentCamera.heading)
            } else {
                newCamera = MKMapCamera()
                newCamera.centerCoordinate = currentCamera.centerCoordinate
                newCamera.heading = currentCamera.heading
                newCamera.altitude = currentCamera.altitude / self.valueCameraMap
                newCamera.pitch = currentCamera.pitch
            }
            
            self.mapView.setCamera(newCamera, animated: true)
            
        }.store(in: reactive.bag)
        
        makeMapSmallerButton.reactive.tap.observeNext {
            let currentCamera = self.mapView.camera
            let newCamera: MKMapCamera
            if #available(iOS 9.0, *) {
                newCamera = MKMapCamera(lookingAtCenter: currentCamera.centerCoordinate
                                        , fromDistance: currentCamera.altitude * self.valueCameraMap,
                                        pitch: currentCamera.pitch,
                                        heading: currentCamera.heading)
            } else {
                newCamera = MKMapCamera()
                newCamera.centerCoordinate = currentCamera.centerCoordinate
                newCamera.heading = currentCamera.heading
                newCamera.altitude = currentCamera.altitude * self.valueCameraMap
                newCamera.pitch = currentCamera.pitch
            }
            
            self.mapView.setCamera(newCamera, animated: true)
            
        }.store(in: reactive.bag)
    }
    
    /// раскидал точки по карте и нарисовал радиус по заданной дистанции
    func setupBinding() {
        self.viewModel.result.observeNext { [weak self] result in
            guard let _self = self else { return }
            
            var annotations: [MKAnnotation] = []
            result.forEach { data in
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(data?.lat ?? _self.defaultValue),
                                                               longitude: CLLocationDegrees(data?.lon ?? _self.defaultValue))
                annotation.title = String(data?.confirmed ?? 0)
                _self.showCircle(coordinate: CLLocationCoordinate2D(
                                    latitude: CLLocationDegrees(data?.lat ?? _self.defaultValue),
                                    longitude: CLLocationDegrees(data?.lon ?? _self.defaultValue)), radius: _self.circleDistance)
                
                annotations.append(annotation)
            }
            _self.mapView.addAnnotations(annotations)
            
        }.store(in: reactive.bag)
    }

    /// метод определния местоположения
    func requestLocation(location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
                
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: latitudeDelta)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    /// метод отрисовки радиуса на карте
    func showCircle(coordinate: CLLocationCoordinate2D,
                    radius: CLLocationDistance) {
        let circle = MKCircle(center: coordinate,
                              radius: radius)
        mapView.addOverlay(circle)
    }
}


// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            requestLocation(location: location)
        }
    }
}
 
// MARK: - MKMapViewDelegate
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
                container.pin(size: layout.containerSize)
                container.pinToSuperview(edges: [.left,.bottom], insets: layout.containerInsets)
                container.layer.masksToBounds = false
                container.layer.cornerRadius = containerForLabelPointCornerRadius

                let confirmedLabel = UILabel()
                confirmedLabel.translatesAutoresizingMaskIntoConstraints = false
                confirmedLabel.textAlignment = .center
                container.addSubview(confirmedLabel)
                confirmedLabel.pin(size: layout.confirmedLabelSize)
                confirmedLabel.pinCenterToSuperview(of: .vertical)
                confirmedLabel.pinToSuperview(edges: [.all], insets: layout.confirmedLabelInsets)
                
                if annotation.title != nil {
                    confirmedLabel.text = annotation.title ?? String()
                } else {
                    container.isHidden = true
                }
                
                confirmedLabel.text = annotation.title ?? String()
                confirmedLabel.font = .boldSystemFont(ofSize: self.confirmedLabelSize)
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
            circleRenderer.fillColor = #colorLiteral(red: 0.02352941176, green: 0.2823529412, blue: 0.6745098039, alpha: 1)
            circleRenderer.alpha = circleRendererAlpha
        }
        return circleRenderer
    }
}


