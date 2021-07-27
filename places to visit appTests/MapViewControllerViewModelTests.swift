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
        XCTAssertFalse(mockUserDefaults.dataWasCalled)
        XCTAssertTrue(mockUserDefaults.dataWasCalledUserDefaultsCurrentlyEmpty)
        XCTAssertTrue(mockUserDefaults.setValueWasCalled)
    }

    func testSavePlaceOfInterestToUserDefaults_withPlacesAlreadyStored() {
        // store data in dict of mock user defaults
        let pointOfInterestOne = MapAnnotationPoint(title: "coffee place one", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1), number: "1", streetAddress: "high street")
        mapAnnotationsStore.mapAnnotationPoints = [pointOfInterestOne]
        
        mockUserDefaults.saved = ["savedPlaces": mapAnnotationsStore]
        
        //call func
        let pointOfInterestTwo = MapAnnotationPoint(title: "coffee place two", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1), number: "1", streetAddress: "high street")
        mapViewControllerViewModel.savePlaceOfInterestToUserDefaults(save: pointOfInterestTwo)
        
        // assertions
        XCTAssertTrue(mockUserDefaults.dataWasCalled)
        XCTAssertFalse(mockUserDefaults.dataWasCalledUserDefaultsCurrentlyEmpty)
        XCTAssertTrue(mockUserDefaults.setValueWasCalled)
       
        // this fails with 2
        XCTAssertEqual(mockUserDefaults.saved["savedPlaces"]?.mapAnnotationPoints.count, 1)
        XCTAssertEqual(mockUserDefaults.saved["savedPlaces"]?.mapAnnotationPoints[0].title, "coffee place one")
    }
}

class MockUserDefaults: UserDefaults {
    var dataWasCalled: Bool = false
    var dataWasCalledUserDefaultsCurrentlyEmpty: Bool = false
    var setValueWasCalled: Bool = false
    
    var previouslySavedData: MapAnnotationsStore?
    // want to make this generic type?
    var saved: Dictionary<String, MapAnnotationsStore> = [String: MapAnnotationsStore]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if value is Data, key == "savedPlaces" {
            setValueWasCalled = true
        }
    }
    
    override func data(forKey defaultName: String) -> Data? {
        if defaultName == "savedPlaces" {
            if let previouslySavedValue = saved["savedPlaces"] {
                dataWasCalled = true
                previouslySavedData = previouslySavedValue
                let jsonEncoder = JSONEncoder()
                if let previouslySavedValue = try? jsonEncoder.encode(previouslySavedValue) {
                    return previouslySavedValue
                }
                return nil
            }
            dataWasCalledUserDefaultsCurrentlyEmpty = true
            return nil
        }
        return nil
    }
}
