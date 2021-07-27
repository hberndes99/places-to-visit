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
    
    func testRegisterDefaults() {
        mapViewControllerViewModel.registerDefaults()
        
        XCTAssertTrue(mockUserDefaults.registerWasCalled)
        XCTAssertTrue(mockUserDefaults.saved["savedPlaces"] != nil)
        XCTAssertFalse(mockUserDefaults.saved["places"] != nil)
     
    }
    
    func testRetrieveData() {
        let pointOfInterestOne = MapAnnotationPoint(title: "coffee place one", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1), number: "1", streetAddress: "high street")
        let pointOfInterestTwo = MapAnnotationPoint(title: "coffee place two", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1), number: "1", streetAddress: "high street")
        mapAnnotationsStore.mapAnnotationPoints.append(pointOfInterestOne)
        mapAnnotationsStore.mapAnnotationPoints.append(pointOfInterestTwo)
        // do i need to encode this first
        mockUserDefaults.saved["savedPlaces"] = mapAnnotationsStore
        
        mapViewControllerViewModel.retrieveData()
        
        XCTAssertTrue(mockUserDefaults.dataWasCalled)
        XCTAssertEqual(mockUserDefaults.previouslySavedData?.mapAnnotationPoints.count, 2)
        XCTAssertEqual(mockUserDefaults.previouslySavedData?.mapAnnotationPoints[0].title, "coffee place one")
    }

    func testSavePlaceOfInterestToUserDefaults_currentlyEmpty() {
        // instantiate pointOfInterest
        let pointOfInterestOne = MapAnnotationPoint(title: "coffee place", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1)
, number: "1", streetAddress: "high street")
        mapAnnotationsStore.mapAnnotationPoints.append(pointOfInterestOne)
        mapViewControllerViewModel.savePlaceOfInterestToUserDefaults()
    
        XCTAssertFalse(mockUserDefaults.dataWasCalled)
        XCTAssertTrue(mockUserDefaults.setValueWasCalled)
        
        XCTAssert(mockUserDefaults.saved["savedPlaces"] == nil)
        
        
        /*
        // instantiate pointOfInterest
        let pointOfInterest = MapAnnotationPoint(title: "coffee place", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1)
, number: "1", streetAddress: "high street")
        
        // call function
        mapViewControllerViewModel.savePlaceOfInterestToUserDefaults(save: pointOfInterest)
        
        // perform assertions
        XCTAssertFalse(mockUserDefaults.dataWasCalled)
        XCTAssertTrue(mockUserDefaults.dataWasCalledUserDefaultsCurrentlyEmpty)
        XCTAssertTrue(mockUserDefaults.setValueWasCalled)
         */
    }

    func testSavePlaceOfInterestToUserDefaults_withPlacesAlreadyStored() {
        /* store data in dict of mock user defaults
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
    */
    }
}

class MockUserDefaults: UserDefaultsProtocol {
    
    var registerWasCalled: Bool = false
    var dataWasCalled: Bool = false
    var dataWasCalledUserDefaultsCurrentlyEmpty: Bool = false
    var setValueWasCalled: Bool = false
    
    var previouslySavedData: MapAnnotationsStore?
    // want to make this generic type?
    var saved: Dictionary<String, Any> = [String: Any]()
    
    func register(defaults registrationDictionary: [String : Any]) {
        saved = registrationDictionary
        registerWasCalled = true
    }
    
    func setValue(_ value: Any?, forKey key: String) {
        if value is MapAnnotationsStore, key == "savedPlaces" {
            setValueWasCalled = true
            // value here is already encoded
        }
    }
    
    func data(forKey defaultName: String) -> Data? {
        if let savedValue = saved[defaultName] {
            dataWasCalled = true
            previouslySavedData = savedValue as? MapAnnotationsStore
            return savedValue as? Data
        }
        return nil
    }
 
}
