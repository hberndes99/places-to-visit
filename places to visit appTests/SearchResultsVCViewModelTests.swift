//
//  SearchResultsVCViewModel.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 23/07/2021.
//

import XCTest
import MapKit
@testable import places_to_visit_app

class SearchResultsVCViewModelTests: XCTestCase {

    var searchResultsVCViewModel: SearchResultsVCViewModel!
    var mockSearchNetworkManager: MockSearchNetworkManager!
    var mockSearchResultsViewControllerDelegate: MockSearchResultsViewControllerDelegate!
    
    
    override func setUpWithError() throws {
        mockSearchNetworkManager = MockSearchNetworkManager()
        mockSearchResultsViewControllerDelegate = MockSearchResultsViewControllerDelegate()
        
        searchResultsVCViewModel = SearchResultsVCViewModel(searchNetworkManager: mockSearchNetworkManager)
        searchResultsVCViewModel.delegate = mockSearchResultsViewControllerDelegate
    }

    override func tearDownWithError() throws {
        searchResultsVCViewModel = nil
        mockSearchNetworkManager = nil
        mockSearchResultsViewControllerDelegate = nil
    }

    func testPerformSearch() throws {
        let mapView = MKMapView()
        let placemark = MKPlacemark(
            coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20)
        )
        mockSearchNetworkManager.response = [
            MKMapItem(placemark: placemark),
            MKMapItem(placemark: placemark)
        ]

        searchResultsVCViewModel.performSearch(mapView: mapView, searchText: "hej")
   
        //this fails with 3
        XCTAssertEqual(searchResultsVCViewModel.searchResults.count, 2)
        XCTAssertTrue(mockSearchResultsViewControllerDelegate.updateTableWithSearchWasCalled)
    }
    
    
   
}

class MockSearchNetworkManager: SearchNetworkManagerProtocol {
    
    var response: [MKMapItem] = []
    
    func startSearch(mapView: MKMapView, searchText: String, factory: MKLocalSearchFactoryProtocol, completion: @escaping ([MKMapItem]) -> Void) {
        completion(response)
    }
}

class MockSearchResultsViewControllerDelegate: SearchResultsViewControllerDelegate {
    var updateTableWithSearchWasCalled: Bool = false
    
    func updateTableWithSearch() {
        updateTableWithSearchWasCalled = true
    }
}

