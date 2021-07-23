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
    
    override func setUpWithError() throws {
        mockSearchNetworkManager = MockSearchNetworkManager()

        searchResultsVCViewModel = SearchResultsVCViewModel(searchNetworkManager: mockSearchNetworkManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        //print(searchResultsVCViewModel.searchResults)
        searchResultsVCViewModel.performSearch(mapView: mapView, searchText: "hej")
        //print(searchResultsVCViewModel.searchResults)
        //print(self.mockSearchNetworkManager.response)
        
        //this fails with 3
        XCTAssertEqual(searchResultsVCViewModel.searchResults.count, 2)

    }

 

}


// mock searchNetworkManager
class MockSearchNetworkManager: SearchNetworkManagerProtocol {
    
    var response: [MKMapItem] = []
    
    func startSearch(mapView: MKMapView, searchText: String, factory: MKLocalSearchFactoryProtocol, completion: @escaping ([MKMapItem]) -> Void) {
        
        completion(response)
        
    }
    
    
}
