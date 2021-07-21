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
    
    func performSearch(mapView: MKMapView, searchText: String) {
        /// perform search
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region  = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response else {
                return
            }
            print(response.mapItems)
            self?.searchResults = response.mapItems
            self?.delegate?.updateTableWithSearch()
        }
    }
}
