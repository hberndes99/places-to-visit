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
    var mapAnnotationsStore: MapAnnotationsStore!
    var mockUserDefaults: MockUserDefaults!
    var pointOfInterestOne: MapAnnotationPoint!
    var pointOfInterestTwo: MapAnnotationPoint!
    
    override func setUpWithError() throws {
        mapAnnotationsStore = MapAnnotationsStore()
        mockUserDefaults = MockUserDefaults()
        
        placesListViewModel = PlacesListViewModel(mapAnnotationsStore: mapAnnotationsStore, userDefaults: mockUserDefaults)
        
        pointOfInterestOne = MapAnnotationPoint(title: "coffee place one", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1), number: "1", streetAddress: "high street")
        pointOfInterestTwo = MapAnnotationPoint(title: "coffee place two", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1), number: "1", streetAddress: "high street")
    }

    override func tearDownWithError() throws {
        mapAnnotationsStore = nil
        placesListViewModel = nil
        mockUserDefaults = nil
    }

    func testRetrieveData() {
        mapAnnotationsStore.mapAnnotationPoints.append(pointOfInterestOne)
        mapAnnotationsStore.mapAnnotationPoints.append(pointOfInterestTwo)
       
        // sets encoded data in the user defaults 'store'
        let jsonEncoder = JSONEncoder()
        guard let encodedMapAnnotationsStore = try? jsonEncoder.encode(mapAnnotationsStore) else {return}
        mockUserDefaults.saved["savedPlaces"] = encodedMapAnnotationsStore
        
        placesListViewModel.retrieveData()
        
        XCTAssertTrue(mockUserDefaults.dataWasCalled)
        XCTAssertEqual(placesListViewModel.mapAnnotationsStore.mapAnnotationPoints.count, 2)
        XCTAssertEqual(placesListViewModel.mapAnnotationsStore.mapAnnotationPoints[0].title, "coffee place one")
    }
    
    func testUpdateUserDefaults() {
        // encodes updated map store and saves it
        placesListViewModel.mapAnnotationsStore.mapAnnotationPoints = [pointOfInterestOne, pointOfInterestTwo]
        
        placesListViewModel.updateUserDefaults()
         // i need to access what was saved and check it is the same as these points
        let jsonDecoder = JSONDecoder()
        guard let decodedSaved = try? jsonDecoder.decode(MapAnnotationsStore.self, from: mockUserDefaults.savedBySetValue["savedPlaces"] as! Data) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(decodedSaved.mapAnnotationPoints.count, 2)
        XCTAssertEqual(decodedSaved.mapAnnotationPoints[1].title, "coffee place two")
    }

    func testUpdateUserDefaults_userDefaultsNotEmpty() {

        mapAnnotationsStore.mapAnnotationPoints = [pointOfInterestOne, pointOfInterestTwo]
        
        // store place one and two in user defaults prior
        let jsonEncoder = JSONEncoder()
        guard let encodedPlaces = try? jsonEncoder.encode(mapAnnotationsStore) else {
            XCTFail()
            return
        }
        mockUserDefaults.savedBySetValue["savedPlaces"] = encodedPlaces
        
        // simulate one point of interest being removed
        placesListViewModel.mapAnnotationsStore.mapAnnotationPoints = [pointOfInterestTwo]
        
        placesListViewModel.updateUserDefaults()
        
        let jsonDecoder = JSONDecoder()
        guard let decodedSaved = try? jsonDecoder.decode(MapAnnotationsStore.self, from: mockUserDefaults.savedBySetValue["savedPlaces"] as! Data) else {
            XCTFail()
            return
        }
        XCTAssertEqual(decodedSaved.mapAnnotationPoints.count, 1)
        XCTAssertEqual(decodedSaved.mapAnnotationPoints[0].title, "coffee place two")
    }
    
    func testDeletePlaceOfInterest() {
        placesListViewModel.mapAnnotationsStore.mapAnnotationPoints = [pointOfInterestOne, pointOfInterestTwo]
        placesListViewModel.deletePlaceOfInterest(at: 0)
        
        XCTAssertEqual(placesListViewModel.mapAnnotationsStore.mapAnnotationPoints.count, 1)
        XCTAssertEqual(placesListViewModel.mapAnnotationsStore.mapAnnotationPoints[0].title, "coffee place two")
    }
    
    func testDeletePlaceOfInterest_dodgyCall() {
        placesListViewModel.mapAnnotationsStore.mapAnnotationPoints = [pointOfInterestOne, pointOfInterestTwo]
        placesListViewModel.deletePlaceOfInterest(at: 2)
        
        XCTAssertEqual(placesListViewModel.mapAnnotationsStore.mapAnnotationPoints.count, 2)
    }
    
}
