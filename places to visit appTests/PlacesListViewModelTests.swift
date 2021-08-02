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
    var wishListStore: WishListStore!
    var mockUserDefaults: MockUserDefaults!
    var pointOfInterestOne: MapAnnotationPoint!
    var pointOfInterestTwo: MapAnnotationPoint!
    var coffeeWishList: WishList!
    
    override func setUpWithError() throws {
        wishListStore = WishListStore(wishLists: [])
        mockUserDefaults = MockUserDefaults()
        
        placesListViewModel = PlacesListViewModel(userDefaults: mockUserDefaults, wishListStore: wishListStore)
        
        pointOfInterestOne = MapAnnotationPoint(title: "coffee place one", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1), number: "1", streetAddress: "high street")
        pointOfInterestTwo = MapAnnotationPoint(title: "coffee place two", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1), number: "1", streetAddress: "high street")
        
        coffeeWishList = WishList(name: "coffee wish list", items: [pointOfInterestOne, pointOfInterestTwo])
    }

    override func tearDownWithError() throws {
        wishListStore = nil
        placesListViewModel = nil
        mockUserDefaults = nil
    }

    func testRetrieveData() {
        wishListStore.wishLists.append(coffeeWishList)
       
        // sets encoded data in the user defaults 'store'
        let jsonEncoder = JSONEncoder()
        guard let encodedWishListStore = try? jsonEncoder.encode(wishListStore) else {
            XCTFail()
            return
        }
        mockUserDefaults.saved["savedPlaces"] = encodedWishListStore
        
        placesListViewModel.retrieveData()
        
        XCTAssertTrue(mockUserDefaults.dataWasCalled)
        XCTAssertEqual(wishListStore.wishLists.count, 1)
        XCTAssertEqual(wishListStore.wishLists[0].name, "coffee wish list")
        XCTAssertEqual(wishListStore.wishLists[0].items.count, 2)
    }
    
    func testUpdateUserDefaults() {
        // encodes updated map store and saves it
        var coffeeWishList = WishList(name: "coffee wish list", items: [pointOfInterestOne, pointOfInterestTwo])
        placesListViewModel.wishListStore.wishLists = [coffeeWishList]
        
        placesListViewModel.updateUserDefaults()
         // i need to access what was saved and check it is the same as these points
        let jsonDecoder = JSONDecoder()
        guard let decodedSaved = try? jsonDecoder.decode(WishListStore.self, from: mockUserDefaults.savedBySetValue["savedPlaces"] as! Data) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(decodedSaved.wishLists.count, 1)
        XCTAssertEqual(decodedSaved.wishLists[0].name, "coffee wish list")
        XCTAssertEqual(decodedSaved.wishLists[0].items.count, 2)
        
    }

    func testUpdateUserDefaults_userDefaultsNotEmpty() {
        wishListStore.wishLists = [coffeeWishList]
        // store place one and two in user defaults prior
        let jsonEncoder = JSONEncoder()
        guard let encodedPlaces = try? jsonEncoder.encode(wishListStore) else {
            XCTFail()
            return
        }
        mockUserDefaults.savedBySetValue["savedPlaces"] = encodedPlaces
        
        // simulate one point of interest being removed
        placesListViewModel.wishListStore.wishLists[0].items = [pointOfInterestTwo]
        
        placesListViewModel.updateUserDefaults()
        
        let jsonDecoder = JSONDecoder()
        guard let decodedSaved = try? jsonDecoder.decode(WishListStore.self, from: mockUserDefaults.savedBySetValue["savedPlaces"] as! Data) else {
            XCTFail()
            return
        }
        XCTAssertEqual(decodedSaved.wishLists[0].name, "coffee wish list")
        XCTAssertEqual(decodedSaved.wishLists[0].items.count, 1)
        XCTAssertEqual(decodedSaved.wishLists[0].items[0].title, "coffee place two")
    }
    
    func testDeletePlaceOfInterest() {
        placesListViewModel.wishListStore.wishLists = [coffeeWishList]
        placesListViewModel.deletePlaceOfInterest(at: 0, from: 0)
        
        XCTAssertEqual(placesListViewModel.wishListStore.wishLists.count, 1)
        XCTAssertEqual(placesListViewModel.wishListStore.wishLists[0].items.count, 1)
        
    }
    
    func testDeletePlaceOfInterest_dodgyCall() {
        placesListViewModel.wishListStore.wishLists = [coffeeWishList]
        placesListViewModel.deletePlaceOfInterest(at: 2, from: 0)
        
        XCTAssertEqual(placesListViewModel.wishListStore.wishLists[0].items.count, 2)
    }
    
}
