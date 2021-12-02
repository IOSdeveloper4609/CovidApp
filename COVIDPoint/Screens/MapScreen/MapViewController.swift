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
        let segmentControlInsets: UIEdgeInsets
        let segmentControlSize: CGSize
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
        let userLocationButtonInsets: UIEdgeInsets
        
        /// Инициализатор
        init(segmentControlInsets: UIEdgeInsets = .init(top: 65, left: 100, bottom: 0, right: 100),
             segmentControlSize: CGSize = .init(width: 200, height: 38),
             mapInsets: UIEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
             containerSize: CGSize = .init(width: 70, height: 20),
             containerInsets: UIEdgeInsets = .init(top: 0, left: -29, bottom: 20, right: 0),
             confirmedLabelSize: CGSize = .init(width: 55, height: 0),
             confirmedLabelInsets: UIEdgeInsets = .init(top: 5, left: 2, bottom: 5, right: 2),
             makeMapBiggerButtonSize: CGSize = .init(width: 35, height: 10),
             makeMapBiggerButtonInsets: UIEdgeInsets = .init(top: 13, left: 10, bottom: 52, right: 10),
             makeMapSmallerButtonSize: CGSize = .init(width: 35, height: 10),
             makeMapSmallerButtonInsets: UIEdgeInsets = .init(top: 55, left: 10, bottom: 10, right: 10),
             containerForButtonsSize: CGSize = .init(width: 41, height: 80),
             containerForButtonsInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0 , right: 10),
             delimiterImageSize: CGSize = .init(width: 35, height: 1),
             delimiterImageInsets: UIEdgeInsets = .init(top: 42, left: 5, bottom: 35, right: 5),
             userLocationButtonInsets: UIEdgeInsets = .init(top: 525, left: 0, bottom: 0, right: 15)) {
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
            self.segmentControlInsets = segmentControlInsets
            self.segmentControlSize = segmentControlSize
            self.userLocationButtonInsets = userLocationButtonInsets
        }
    }
    
    // Внешний вид
    struct Appearance: AppearanceProtocol {
        let annotationImage: String
        let reuseId: String
        let smallerImage: String
        let biggerImage: String
        let delimiterImage: String
        let mapImage: String
        let listImage: String
        let userLocationButtonIcon: String
        
        init(annotationImage: String = "pin",
             reuseId: String = "pin",
             smallerImage: String = "smaller",
             biggerImage: String = "bigger",
             delimiterImage: String = "delimiter",
             mapImage: String = "map",
             listImage: String = "list",
             userLocationButtonIcon: String = "geolocation") {
            self.reuseId = reuseId
            self.annotationImage = annotationImage
            self.smallerImage = smallerImage
            self.biggerImage = biggerImage
            self.delimiterImage = delimiterImage
            self.mapImage = mapImage
            self.listImage = listImage
            self.userLocationButtonIcon = userLocationButtonIcon
        }
    }
}

final class MapViewController: UIViewController {
    private let mapView = MKMapView()
    private var segmentControl = UISegmentedControl()
    private var layout: Layout = Layout()
    private var appearance: Appearance = Appearance()
    private let viewModel: MapViewModelProtocol!
    private let locationManager = CLLocationManager()
    private var circle = MKCircle()
    private let makeMapBiggerButton = UIButton()
    private let makeMapSmallerButton = UIButton()
    private let delimiterImage = UIImageView()
    private let containerForButtons = UIView()
    private let numberFormatter = NumberFormatter()
    private let userLocationButton = UIButton()
    
    /// Инициализатор
    /// - Parameter viewModel: MapViewModelProtocol
    init(viewModel: MapViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.segmentControl.selectedSegmentIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("first screen loaded")
       
    }
    
    override func loadView() {
        super.loadView()
        
        setupBinding()
        addAndSetupSubviews(layout: self.layout)
        apply(appearance: self.appearance)
        setupLocationManager()
        viewModel.getCountries()
        setupCameraZoomRange()
    }
    
    
}

// MARK: - Private
private extension MapViewController {
    func addAndSetupSubviews(layout: Layout) {
        /// настройка форматтера чисел
        numberFormatter.groupingSeparator = " "
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        /// настройка карты
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.delegate = self
        self.view.addSubview(mapView)
        self.mapView.pinToSuperview(edges: [.all],
                                    insets: layout.mapInsets,
                                    safeArea: false,
                                    priority: .required)

        /// Настройка SegmentControl
        let segmentImage: [UIImage?] = [UIImage(named: appearance.mapImage),
                                       UIImage(named: appearance.listImage)]
        segmentControl = UISegmentedControl(items: segmentImage as [Any])
        segmentControl.selectedSegmentIndex = 0
        self.segmentControl.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.addSubview(self.segmentControl)
        self.segmentControl.pinToSuperview(edges: [.top, .left, .right],
                                           insets: layout.segmentControlInsets,
                                           safeArea: false,
                                           priority: .required)
        self.segmentControl.addTarget(self, action: #selector(openListScreenViewController), for: .valueChanged)
        
        /// настройка контейнера для кнопок
        self.containerForButtons.translatesAutoresizingMaskIntoConstraints = false
        self.containerForButtons.backgroundColor = UIColor.backgroundContainerForButtons
        self.mapView.addSubview(containerForButtons)
        self.containerForButtons.layer.cornerRadius = viewModel.containerForButtonsCornerRadius
        self.containerForButtons.pin(size: layout.containerForButtonsSize)
        self.containerForButtons.pinToSuperview(edges: [.right],
                                           insets: layout.containerForButtonsInsets)
        self.containerForButtons.pinCenterToSuperview(of: .vertical)
        
        /// настройка кнопки приближения карты
        self.makeMapBiggerButton.translatesAutoresizingMaskIntoConstraints = false
        self.makeMapBiggerButton.setImage(UIImage(named: appearance.biggerImage), for: .normal)
        self.containerForButtons.addSubview(makeMapBiggerButton)
        self.makeMapBiggerButton.contentMode = .scaleAspectFit
        self.makeMapBiggerButton.pinToSuperview(edges: [.all],
                                           insets: layout.makeMapBiggerButtonInsets)
        /// настройка кнопки отдаления карты
        self.makeMapSmallerButton.translatesAutoresizingMaskIntoConstraints = false
        self.makeMapSmallerButton.setImage(UIImage(named: appearance.smallerImage), for: .normal)
        self.containerForButtons.addSubview(makeMapSmallerButton)
        self.makeMapSmallerButton.contentMode = .scaleAspectFit
        self.makeMapSmallerButton.pinToSuperview(edges: [.all],
                                            insets: layout.makeMapSmallerButtonInsets)
        
        /// настройка картинки разделения кнопок
        self.delimiterImage.translatesAutoresizingMaskIntoConstraints = false
        self.delimiterImage.image = UIImage(named: appearance.delimiterImage)
        self.containerForButtons.addSubview(delimiterImage)
        self.delimiterImage.pinToSuperview(edges: [.all],
                                            insets: layout.delimiterImageInsets)
        
        
        self.userLocationButton.translatesAutoresizingMaskIntoConstraints = false
        self.userLocationButton.setImage(UIImage(named: appearance.userLocationButtonIcon), for: .normal)
        self.mapView.addSubview(userLocationButton)
        self.userLocationButton.contentMode = .scaleAspectFit
        self.userLocationButton.pinToSuperview(edges: [.top, .right],
                                               insets: layout.userLocationButtonInsets)
        self.userLocationButton.addTarget(self, action: #selector(locationManagerButton), for: .touchUpInside)
        
    }
    
    @objc func locationManagerButton() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    @objc func openListScreenViewController() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            print("selectedSegmentIndex")
        default:
//            let listScreen = ListScreenViewController(layout: .init(),
//                                                      appearance: .init(),
//                                                      viewModel: ListScreenViewModel(data: LocalSessionManager.shared.covidData?.data ?? []))
//            listScreen.modalPresentationStyle = .fullScreen
//            self.present(listScreen, animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    /// Применение стилей
    private func apply(appearance: MapViewController.Appearance) {
        self.segmentControl.apply(style: appearance.screenChangeControlStyle)
    }
    
    /// настройка locationManager
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
            
            let annotations = result.compactMap { data -> MKAnnotation in
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: data?.lat ?? 0.0,
                                                               longitude: data?.lon ?? 0.0)
                
                let numberResult = Int(data?.confirmed ?? 0)
            
                annotation.title = _self.numberFormatter.string(from: (numberResult as NSNumber ))
                annotation.subtitle = String(data?.id ?? 0)
                
                _self.showCircle(coordinate: CLLocationCoordinate2D(latitude: data?.lat ?? _self.viewModel.defaultValue,
                                                                    longitude: data?.lon ?? _self.viewModel.defaultValue),
                                                                     radius: _self.viewModel.circleDistance)
                return annotation
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
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
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
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//            let reuseId = appearance.reuseId
//
//            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
//            if annotationView == nil {
//                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//                annotationView?.canShowCallout = true
//                let container = UIView()
//                container.backgroundColor = .white
//                annotationView?.addSubview(container)
//                container.translatesAutoresizingMaskIntoConstraints = false
//                container.pin(size: layout.containerSize)
//                container.pinToSuperview(edges: [.left,.bottom],
//                                         insets: layout.containerInsets)
//                container.layer.masksToBounds = false
//                container.layer.cornerRadius = viewModel.containerForLabelPointCornerRadius
//
//                let confirmedLabel = UILabel()
//                confirmedLabel.translatesAutoresizingMaskIntoConstraints = false
//                confirmedLabel.textAlignment = .center
//                annotationView?.addSubview(confirmedLabel)
//                confirmedLabel.pinCenterToSuperview(of: .vertical)
//                confirmedLabel.pinToSuperview(edges: [.all],
//                                              insets: layout.confirmedLabelInsets)
//
//                let result = Int((annotationView?.annotation?.title ?? "") ?? "")
//                confirmedLabel.text = numberFormatter.string(from: result as NSNumber? ?? 0)
//                confirmedLabel.font = .boldSystemFont(ofSize: viewModel.confirmedLabelSize)
//                confirmedLabel.textColor = .black
//                annotationView?.image = UIImage(named: appearance.annotationImage)
//            } else {
//                annotationView?.annotation = annotation
//            }
//            return annotationView
//        }
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        var circleRenderer = MKCircleRenderer()
//        if let overlay = overlay as? MKCircle {
//            circleRenderer = MKCircleRenderer(circle: overlay)
//            circleRenderer.fillColor = UIColor.backgroundCircleRadius
//            circleRenderer.alpha = viewModel.circleRendererAlpha
//        }
//        
//        return circleRenderer
//    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let id = Int((view.annotation?.subtitle ?? "") ?? "") else { return }
        let detailVC  = DetailViewController.getSheetViewController(id)
        self.present(detailVC, animated: true, completion: nil)
        mapView.selectedAnnotations.removeAll()
    }
}

