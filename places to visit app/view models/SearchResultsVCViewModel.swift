//
//  SearchResultsVCViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 21/07/2021.
//

import Foundation
import MapKit

class SearchResultsVCViewModel {
    var delegate: SearchResultsViewControllerDelegate?
    var searchResults: [MKMapItem] = []
    var searchNetworkManager: SearchProtocol
    
    init (searchNetworkManager: SearchProtocol) {
        self.searchNetworkManager = searchNetworkManager
    }
    
    func performSearch(mapView: MKMapView, searchText: String) {
        searchNetworkManager.startSearch(mapView: mapView, searchText: searchText, factory: MKLocalSearchFactory()) { [weak self] searchResults in
            self?.searchResults = searchResults
            self?.delegate?.updateTableWithSearch()
        } 
    }
}
