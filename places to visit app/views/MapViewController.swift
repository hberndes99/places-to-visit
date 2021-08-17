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
    
    var filterButtonButton: UIButton!
    var removeFiltersButton: UIButton!
    
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
        mapViewControllerViewModel.mapViewControllerViewModelDelegate = self
        mapViewControllerViewModel.retrieveData()
        
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        self.view.addSubview(mapView)
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(mapView: )))
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "add place of interest button"
        
        filterButtonButton = UIButton()
        filterButtonButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        filterButtonButton.setTitle("Filter", for: .normal)
        filterButtonButton.setTitleColor(.systemBlue, for: .normal)
        filterButtonButton.translatesAutoresizingMaskIntoConstraints = false
        filterButtonButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        removeFiltersButton = UIButton()
        removeFiltersButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        removeFiltersButton.setTitle("Remove filters", for: .normal)
        removeFiltersButton.setTitleColor(.systemBlue, for: .normal)
        removeFiltersButton.translatesAutoresizingMaskIntoConstraints = false
        removeFiltersButton.addTarget(self, action: #selector(removeFiltersButtonTapped), for: .touchUpInside)
        
        setUpLeftBarButtons()
        setUpConstraints()
        updateMapAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    @objc func filterButtonTapped() {
        let filterVC = FilterViewController(wishListStore: wishListStore)
        filterVC.filterViewControllerDelegate = self
        self.present(filterVC, animated: true)
    }
    
    @objc func removeFiltersButtonTapped() {
        mapViewControllerViewModel.clearFilters()
        updateMapAnnotations()
        setUpLeftBarButtons()
    }
    
    func setUpLeftBarButtons() {
        if mapViewControllerViewModel.filteringInPlace {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: removeFiltersButton)
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: filterButtonButton)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            print("location access granted")
            mapViewControllerViewModel.setUserLocation(currentLocation: location)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }
}

extension MapViewController: SearchResultsVCMapViewVCDelegate {
    func savePlaceOfInterest(placeOfInterest: MKMapItem, wishListPositionIndex: Int) {
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: placeOfInterest, wishListPositionIndex: wishListPositionIndex)
    }
}

extension MapViewController: FilterViewControllerDelegate {
    func applyFilters(filterList: [String]?, distance: Int?) {
        mapViewControllerViewModel.applyFiltersToMap(filterList: filterList, distance: distance)
    }
}


extension MapViewController: MapViewControllerViewModelDelegate {
    func updateMapWithFilters() {
        updateMapAnnotations()
        setUpLeftBarButtons()
    }
}
