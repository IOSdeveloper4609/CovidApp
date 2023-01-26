//
//  ViewController.swift
//  apicovidtest
//
//  Created by Azat Kirakosyan on 18.10.2021.
//

import UIKit
import MapKit
import ReactiveKit
import Bond

private extension MapViewController {
    /// Отступы
    struct Layout {
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
             containerSize: CGSize = CGSize(width: 60, height: 25),
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
    private var layout: Layout = Layout()
    private var appearance: Appearance = Appearance()
    private let viewModel: MapViewModelProtocol!
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private var circle = MKCircle()
    private let makeMapBiggerButton = UIButton()
    private let makeMapSmallerButton = UIButton()
    private let delimiterImage = UIImageView()
    private let containerForButtons = UIView()
    private let numberFormatter = NumberFormatter()
    
    /// Инициализатор
    /// - Parameter viewModel: MapViewModelProtocol
    init(viewModel: MapViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        viewModel.getCountries()
        addAndSetupSubviews(layout: layout)
    }
}

// MARK: - Private
private extension MapViewController {
    
    func addAndSetupSubviews(layout: Layout) {
        setupLocationManager()
        setupMapView()
        setupContainerForButtons()
        setupMakeMapBiggerButton()
        setupMakeMapSmallerButton()
        setupDelimiterImage()
        setupCameraZoomRange()
    }
    
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
        containerForButtons.backgroundColor = UIColor.backgroundContainerForButtons
        mapView.addSubview(containerForButtons)
        containerForButtons.layer.cornerRadius = viewModel.containerForButtonsCornerRadius
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
                minCenterCoordinateDistance: viewModel.minCamera,
                maxCenterCoordinateDistance: viewModel.maxCamera)
        }
    }
        
    /// раскидал точки по карте и нарисовал радиус по заданной дистанции
    func setupBinding() {
        self.viewModel.result.observeNext { [weak self] result in
            guard let _self = self else { return }
            var annotations: [MKAnnotation] = []
            result.forEach { data in
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(data?.lat ?? _self.viewModel.defaultValue),
                                                               longitude: CLLocationDegrees(data?.lon ?? _self.viewModel.defaultValue))
                annotation.title = String(data?.confirmed ?? 0)
                _self.showCircle(coordinate: CLLocationCoordinate2D(
                                    latitude: CLLocationDegrees(data?.lat ?? _self.viewModel.defaultValue),
                                    longitude: CLLocationDegrees(data?.lon ?? _self.viewModel.defaultValue)), radius: _self.viewModel.circleDistance)
                
                annotations.append(annotation)
            }
            _self.mapView.addAnnotations(annotations)
            
        }.store(in: reactive.bag)
        
        /// повесил нажатие на кнопку
        makeMapBiggerButton.reactive.tap.observeNext {
            let currentCamera = self.mapView.camera
            let newCamera: MKMapCamera
            if #available(iOS 9.0, *) {
                newCamera = MKMapCamera(lookingAtCenter: currentCamera.centerCoordinate,
                                        fromDistance: currentCamera.altitude / self.viewModel.valueCameraMap,
                                        pitch: currentCamera.pitch,
                                        heading: currentCamera.heading)
            } else {
                newCamera = MKMapCamera()
                newCamera.centerCoordinate = currentCamera.centerCoordinate
                newCamera.heading = currentCamera.heading
                newCamera.altitude = currentCamera.altitude / self.viewModel.valueCameraMap
                newCamera.pitch = currentCamera.pitch
            }
            
            self.mapView.setCamera(newCamera, animated: true)
            
        }.store(in: reactive.bag)
        
        /// повесил нажатие на кнопку
        makeMapSmallerButton.reactive.tap.observeNext {
            let currentCamera = self.mapView.camera
            let newCamera: MKMapCamera
            if #available(iOS 9.0, *) {
                newCamera = MKMapCamera(lookingAtCenter: currentCamera.centerCoordinate
                                        , fromDistance: currentCamera.altitude * self.viewModel.valueCameraMap,
                                        pitch: currentCamera.pitch,
                                        heading: currentCamera.heading)
            } else {
                newCamera = MKMapCamera()
                newCamera.centerCoordinate = currentCamera.centerCoordinate
                newCamera.heading = currentCamera.heading
                newCamera.altitude = currentCamera.altitude * self.viewModel.valueCameraMap
                newCamera.pitch = currentCamera.pitch
            }
            
            self.mapView.setCamera(newCamera, animated: true)
            
        }.store(in: reactive.bag)
    }

    /// метод определния местоположения
    func requestLocation(location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
                
        let span = MKCoordinateSpan(latitudeDelta: viewModel.latitudeDelta, longitudeDelta: viewModel.latitudeDelta)
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
                container.layer.cornerRadius = viewModel.containerForLabelPointCornerRadius

                let confirmedLabel = UILabel()
                confirmedLabel.translatesAutoresizingMaskIntoConstraints = false
                confirmedLabel.textAlignment = .center
                container.addSubview(confirmedLabel)
                confirmedLabel.pin(size: layout.confirmedLabelSize)
                confirmedLabel.pinCenterToSuperview(of: .vertical)
                confirmedLabel.pinToSuperview(edges: [.all], insets: layout.confirmedLabelInsets)
                
                numberFormatter.groupingSeparator = " "
                numberFormatter.numberStyle = .decimal
                numberFormatter.maximumFractionDigits = 2
                
                let result = Int((annotationView?.annotation?.title ?? "") ?? "")
                confirmedLabel.text = numberFormatter.string(from: result as NSNumber? ?? 0)
                confirmedLabel.font = .boldSystemFont(ofSize: viewModel.confirmedLabelSize)
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
            circleRenderer.fillColor = UIColor.backgroundCircleRadius
            circleRenderer.alpha = viewModel.circleRendererAlpha
        }
        return circleRenderer
    }
}

