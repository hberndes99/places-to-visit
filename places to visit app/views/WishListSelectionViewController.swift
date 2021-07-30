//
//  WishListSelectionViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 30/07/2021.
//

import UIKit
import MapKit

class WishListSelectionViewController: UIViewController {
    //var button: UIButton!
    var mapViewController: MapViewController
    var mapView: MKMapView
    var wishListStore: WishListStore
    
    init(mapViewController: MapViewController, mapView: MKMapView, wishListStore: WishListStore) {
        self.mapViewController = mapViewController
        self.mapView = mapView
        self.wishListStore = wishListStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonTapped))
        
        //setUpConstraints()
    }
    
    @objc private func buttonTapped() {
        let searchResultsViewController = SearchResultsViewController(mapView: mapView)
        searchResultsViewController.searchResultsVCMapViewVCDelegate = mapViewController
        navigationController?.pushViewController(searchResultsViewController, animated: true)
    }
    
    

}
