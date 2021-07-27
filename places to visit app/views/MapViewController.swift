//
//  ViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 21/07/2021.
//

import UIKit
import MapKit
import CoreLocation


// should i use this to get the map annotations to update
protocol MapViewControllerDelegate: AnyObject {
    func updateMapAnnotations()
}

class MapViewController: UIViewController {

    var mapViewControllerViewModel: MapViewControllerViewModel!
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var mapAnnotationsStore: MapAnnotationsStore
    
    init (mapAnnotationsStore: MapAnnotationsStore) {
        self.mapAnnotationsStore = mapAnnotationsStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved places"
        view.accessibilityIdentifier = "Saved places map view"
        
        mapViewControllerViewModel = MapViewControllerViewModel(mapAnnotationsStore: mapAnnotationsStore)
        mapViewControllerViewModel.registerDefaults()
        mapViewControllerViewModel.retrieveData()
        
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        self.view.addSubview(mapView)
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        setUpConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(mapView: )))
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "add place of interest button"
        
        updateMapAnnotations()
    }
    
    func updateMapAnnotations() {
        mapView.addAnnotations(mapViewControllerViewModel.mapAnnotationsStore.mapAnnotationPoints)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    @objc func addButtonTapped(mapView: MKMapView) {
        let searchResultsViewController = SearchResultsViewController(mapView: self.mapView)
        searchResultsViewController.searchResultsVCMapViewVCDelegate = self
        navigationController?.pushViewController(searchResultsViewController, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            print("location access granted")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}


extension MapViewController: SearchResultsVCMapViewVCDelegate {
    func savePlaceOfInterest(placeOfInterest: MKMapItem) {
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: placeOfInterest)
        updateMapAnnotations()
    }
    
    
}

