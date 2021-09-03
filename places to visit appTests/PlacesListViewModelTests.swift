//
//  PlacesListViewModel.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 30/07/2021.
//

import XCTest
@testable import places_to_visit_app
import MapKit

class PlacesListViewModelTests: XCTestCase {
    
    var placesListViewModel: PlacesListViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        placesListViewModel = PlacesListViewModel(networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
        placesListViewModel = nil
        mockNetworkManager = nil
    }

    func testRetrieveData() {
        placesListViewModel.retrieveData()
        
        XCTAssertEqual(placesListViewModel.wishListStore.count, 2)
        XCTAssertEqual(placesListViewModel.wishListStore[0].items.count, 2)
    }
}
