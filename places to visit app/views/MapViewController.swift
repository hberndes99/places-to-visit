//
//  ViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 21/07/2021.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    var mapViewControllerViewModel: MapViewControllerViewModel!
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var wishListStore: WishListStore
    
    init (wishListStore: WishListStore) {
        self.wishListStore = wishListStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Saved places"
        view.accessibilityIdentifier = "Saved places map view"
        
        mapViewControllerViewModel = MapViewControllerViewModel(wishListStore: wishListStore)
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
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear calledI have an upd")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear called for map view")
        mapViewControllerViewModel.retrieveData()
        updateMapAnnotations()
    }
    
    func updateMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        for wishList in mapViewControllerViewModel.wishListStore.wishLists {
            mapView.addAnnotations(wishList.items)
        }
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
        let wishListSelectionViewController = WishListSelectionViewController(mapViewController: self, mapView: self.mapView, wishListStore: wishListStore)
        navigationController?.pushViewController(wishListSelectionViewController, animated: true)
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
    func savePlaceOfInterest(placeOfInterest: MKMapItem, wishListPositionIndex: Int) {
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: placeOfInterest, wishListPositionIndex: wishListPositionIndex)
    }

}

