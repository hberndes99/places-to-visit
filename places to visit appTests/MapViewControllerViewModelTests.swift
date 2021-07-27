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
        let pointOfInterestOne = MapAnnotationPoint(title: "coffee place", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1), number: "1", streetAddress: "high street")
        mapAnnotationsStore.mapAnnotationPoints.append(pointOfInterestOne)
        mapViewControllerViewModel.savePlaceOfInterestToUserDefaults()
    
        XCTAssertFalse(mockUserDefaults.dataWasCalled)
        XCTAssertTrue(mockUserDefaults.setValueWasCalled)
        
        XCTAssert(mockUserDefaults.saved["savedPlaces"] != nil)
        XCTAssert(mockUserDefaults.saved["places"] == nil)
        
       //let savedValue = mockUserDefaults.saved["savedPlaces"] as? MapAnnotationsStore
        //XCTAssertEqual(savedValue.mapAnnotationPoints.count, 2)
    }
    
    func testSavePlaceOfInterest_storeCurrentlyEmpty() {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), addressDictionary: nil)
        
        let coffeePlaceOne = MKMapItem(placemark: placemark)
        coffeePlaceOne.name = "coffee place one"
    
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: coffeePlaceOne)

        
        XCTAssertEqual(mapAnnotationsStore.mapAnnotationPoints.count, 1)
        XCTAssertEqual(mapAnnotationsStore.mapAnnotationPoints[0].title, coffeePlaceOne.name)
    }
    
    func testSavePlaceOfInterest_storeCurrentlyContainsTwoItems() {
        let coffeePlaceOne = MapAnnotationPoint(title: "coffee place one", subtitle: "1, the street", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), number: "1", streetAddress: "the street")
        let coffeePlaceTwo = MapAnnotationPoint(title: "coffee place two", subtitle: "2, the street", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), number: "2", streetAddress: "the street")
        
        mapAnnotationsStore.mapAnnotationPoints = [coffeePlaceOne, coffeePlaceTwo]
        
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 30, longitude: 20), addressDictionary: nil)
        let coffeePlaceThree = MKMapItem(placemark: placemark)
        coffeePlaceThree.name = "coffee place three"
        
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: coffeePlaceThree)
        
        XCTAssertEqual(mapAnnotationsStore.mapAnnotationPoints.count, 3)
        XCTAssertEqual(mapAnnotationsStore.mapAnnotationPoints[2].title, "coffee place three")
        XCTAssertEqual(mapAnnotationsStore.mapAnnotationPoints[2].coordinate.latitude, CLLocationDegrees(30))
    }
    
    func testSavePlaceOfInterest_storeAlreadyContainsItemToSave() {
        let coffeePlaceOne = MapAnnotationPoint(title: "coffee place one", subtitle: "1, the street", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), number: "1", streetAddress: "the street")
        let coffeePlaceTwo = MapAnnotationPoint(title: "coffee place two", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), number: "2", streetAddress: "the street")
        
        mapAnnotationsStore.mapAnnotationPoints = [coffeePlaceOne, coffeePlaceTwo]
        
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), addressDictionary: nil)
        let coffeePlaceThree = MKMapItem(placemark: placemark)
        coffeePlaceThree.name = "coffee place two"
        // has the same name and subtitle as coffeePlaceTwo so shouldn't be added
        
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: coffeePlaceThree)
        
        XCTAssertEqual(mapAnnotationsStore.mapAnnotationPoints.count, 2)
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
        setValueWasCalled = true
        saved[key] = value
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


