//
//  SearchNetworkManager.swift
//  places to visit app
//
//  Created by Harriette Berndes on 22/07/2021.
//

import Foundation
import MapKit

class SearchNetworkManager: SearchProtocol {
    
    func startSearch(mapView: MKMapView, searchText: String, completion: @escaping ([MKMapItem]) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region  = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                return
            }
            completion(response.mapItems)
        }
    }
    
}
