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
    
    func performSearch(mapView: MKMapView, searchText: String) {
        /// perform search
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region  = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                return
            }
            // self.searchResults = response.mapItems
            // self.searchResultsTable.reloadData()
            // this print works so the search request works
            print(response.mapItems)
            self.delegate?.updateTableWithSearch(response: response.mapItems)
        }
    }
}
