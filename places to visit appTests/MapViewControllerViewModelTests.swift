//
//  MapViewControllerViewModelTests.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 26/07/2021.
//

import XCTest
import MapKit
@testable import places_to_visit_app

class MapViewControllerViewModelTests: XCTestCase {

    var mapViewControllerViewModel: MapViewControllerViewModel!
    var mapAnnotationsStore: MapAnnotationsStore!
    var mockUserDefaults: MockUserDefaults!
    
    override func setUpWithError() throws {
        mapAnnotationsStore = MapAnnotationsStore()
        mockUserDefaults = MockUserDefaults()
    
       mapViewControllerViewModel = MapViewControllerViewModel(mapAnnotationsStore: mapAnnotationsStore, userDefaults: mockUserDefaults)
    }

    override func tearDownWithError() throws {
        mapViewControllerViewModel = nil
        mapAnnotationsStore = nil
        mockUserDefaults = nil
    }

    func testSavePlaceOfInterestToUserDefaults_currentlyEmpty() {
        // instantiate pointOfInterest
        let pointOfInterest = MapAnnotationPoint(title: "coffee place", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1)
, number: "1", streetAddress: "high street")
        
        // call function
        mapViewControllerViewModel.savePlaceOfInterestToUserDefaults(save: pointOfInterest)
        
        // perform assertions
        XCTAssertTrue(mockUserDefaults.setValueWasCalled)
        // this fails with 2
        XCTAssertEqual(mockUserDefaults.dataWasCalled, 1)
    }
}

class MockUserDefaults: UserDefaults {
    var dataWasCalled: Int = 0
    var setValueWasCalled: Bool = false
    
    override func setValue(_ value: Any?, forKey key: String) {
        if value is Data, key == "savedPlaces" {
            setValueWasCalled = true
        }
    }
    
    override func data(forKey defaultName: String) -> Data? {
        if defaultName == "savedPlaces" {
            dataWasCalled += 1
            return nil
        }
        return nil
    }
}
