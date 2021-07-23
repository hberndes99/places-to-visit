//
//  LocalSearchRequestTest.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 22/07/2021.
//

import XCTest
import MapKit
@testable import places_to_visit_app

class SearchNetworkManagerTests: XCTestCase {

    var searchNetworkManager: SearchNetworkManager!

    override func setUpWithError() throws {
        searchNetworkManager = SearchNetworkManager()
    }

    override func tearDownWithError() throws {
        searchNetworkManager = nil
    }

    /// Given I search for 'cafe nero'
    /// And the map kit services responds successfully
    /// Then I should get map locations
    func testStartSearch_successfulSearch_locationsReturned() throws {

        let mapView = MKMapView()
        let mockFactory = MockMKLocalSearchFactory()
        let mockLocalSearch = MockLocalSearch()
        mockFactory.localSearchToReturn = mockLocalSearch

        let response = MockResponse()
        let placemark = MKPlacemark(
            coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20)
        )
        response.mapItemsToReturn = [
            MKMapItem(placemark: placemark),
            MKMapItem(placemark: placemark)
        ]

        mockLocalSearch.itemsToReturn = response

        let expectation = self.expectation(description: "")
        searchNetworkManager.startSearch(mapView: mapView, searchText: "cafe nero", factory: mockFactory) { mapItems in
            XCTAssertEqual(mapItems.count, 2)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testStartSearch_failure_returnsNoResponse() {
        // todo
        let mapView = MKMapView()
        let mockFactory = MockMKLocalSearchFactory()
        let mockLocalSearch = MockLocalSearch()
        mockFactory.localSearchToReturn = mockLocalSearch
        
        let expectation = self.expectation(description: "")
        searchNetworkManager.startSearch(mapView: mapView, searchText: "cafe nero", factory: mockFactory) { mapItems in
            //  XCTAssertEqual(mapItems.count, 3) this fails as expected
            XCTAssertEqual(mapItems.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
}
