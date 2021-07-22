//
//  SearchProtocol.swift
//  places to visit app
//
//  Created by Harriette Berndes on 22/07/2021.
//

import Foundation
import MapKit

protocol SearchProtocol {
    func startSearch(mapView: MKMapView,
                     searchText: String,
                     factory: MKLocalSearchFactoryProtocol,
                     completion: @escaping ([MKMapItem]) -> Void)
}
