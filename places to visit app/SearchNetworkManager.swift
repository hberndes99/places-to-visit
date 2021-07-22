//
//  SearchNetworkManager.swift
//  places to visit app
//
//  Created by Harriette Berndes on 22/07/2021.
//

import Foundation
import MapKit

class SearchNetworkManager: SearchProtocol {

    func startSearch(mapView: MKMapView,
                     searchText: String,
                     factory: MKLocalSearchFactoryProtocol,
                     completion: @escaping ([MKMapItem]) -> Void) {

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region

        let search = factory.buildMKLocalSearch(with: request)
        search.start { response, error in
            guard let response = response else {
                return
            }
            completion(response.mapItems)
        }
    }
}

protocol MKLocalSearchFactoryProtocol {
    func buildMKLocalSearch(with request: MKLocalSearch.Request) -> LocalSearchProtocol
}
class MKLocalSearchFactory: MKLocalSearchFactoryProtocol {
    func buildMKLocalSearch(with request: MKLocalSearch.Request) -> LocalSearchProtocol {
        return MKLocalSearch(request: request)
    }
}

protocol LocalSearchProtocol {
    func start(completionHandler: @escaping MKLocalSearch.CompletionHandler)
}
extension MKLocalSearch: LocalSearchProtocol {}
