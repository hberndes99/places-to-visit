//
//  MockSearchObjects.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 23/07/2021.
//

import Foundation
import MapKit
@testable import places_to_visit_app

class MockResponse: MKLocalSearch.Response {

    var mapItemsToReturn: [MKMapItem] = []

    override var mapItems: [MKMapItem] {
        return mapItemsToReturn
    }
}

class MockMKLocalSearchFactory: MKLocalSearchFactoryProtocol {

    var localSearchToReturn: MockLocalSearch?

    func buildMKLocalSearch(with request: MKLocalSearch.Request) -> LocalSearchProtocol {
        return localSearchToReturn ?? MockLocalSearch()
    }
}

class MockLocalSearch: LocalSearchProtocol {

    var itemsToReturn: MKLocalSearch.Response? = nil
    var error: Error? = nil

    func start(completionHandler: @escaping MKLocalSearch.CompletionHandler) {
        DispatchQueue.main.async {
            completionHandler(self.itemsToReturn, self.error)
        }
    }
}
