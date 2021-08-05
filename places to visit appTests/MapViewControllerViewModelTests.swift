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
    var wishListStore: WishListStore!
    var mockUserDefaults: MockUserDefaults!
    var mockUserDefaultsHelper: MockUserDefaultsHelper.Type!
    
    override func setUpWithError() throws {
        wishListStore = WishListStore(wishLists: [])
        mockUserDefaults = MockUserDefaults()
        mockUserDefaultsHelper = MockUserDefaultsHelper.self
    
       mapViewControllerViewModel = MapViewControllerViewModel(
            wishListStore: wishListStore,
            userDefaults: mockUserDefaults,
            userDefaultsHelper: mockUserDefaultsHelper)
    }

    override func tearDownWithError() throws {
        mapViewControllerViewModel = nil
        wishListStore = nil
        mockUserDefaults = nil
    }

    // new test
    func testRetrieveData() {
        mapViewControllerViewModel.retrieveData()
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].name, "test coffee list")
    }
    
    //new test
    func testSavePlaceOfInterestToUserDefaults() {
        mapViewControllerViewModel.savePlaceOfInterestToUserDefaults()
        
        XCTAssertTrue(mockUserDefaultsHelper.updateUserDefaultsWasCalled)
    }

    /*
    func testSavePlaceOfInterestToUserDefaults_currentlyEmpty() {
        let pointOfInterestOne = MapAnnotationPoint(title: "coffee place", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1), number: "1", streetAddress: "high street")
        let coffeeWishList = WishList(name: "coffee wish list", items: [pointOfInterestOne], description: "london coffee")
        mapViewControllerViewModel.wishListStore.wishLists = [coffeeWishList]
        
        mapViewControllerViewModel.savePlaceOfInterestToUserDefaults()
        
        let jsonDecoder = JSONDecoder()
        guard let decodedData = try? jsonDecoder.decode(WishListStore.self, from: mockUserDefaults.savedBySetValue["savedPlaces"] as! Data) else {
            XCTFail()
            return
        }

        XCTAssertFalse(mockUserDefaults.dataWasCalled)
        XCTAssertTrue(mockUserDefaults.setValueWasCalled)
        
        XCTAssert(mockUserDefaults.savedBySetValue["savedPlaces"] != nil)
        XCTAssert(mockUserDefaults.savedBySetValue["places"] == nil)
        XCTAssertEqual(decodedData.wishLists[0].items[0].title, "coffee place")
        XCTAssertEqual(decodedData.wishLists[0].items[0].coordinate.latitude, CLLocationDegrees(0.2))
    }
    */
    
    func testSavePlaceOfInterest_storeCurrentlyEmpty() {
        let coffeeWishList = WishList(name: "coffee wish list", items: [], description: "london coffee")
        mapViewControllerViewModel.wishListStore.wishLists = [coffeeWishList]
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), addressDictionary: nil)
        let coffeePlaceOne = MKMapItem(placemark: placemark)
        coffeePlaceOne.name = "coffee place one"
    
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: coffeePlaceOne, wishListPositionIndex: 0)

        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].title, "coffee place one")
    }
    
    func testSavePlaceOfInterest_storeCurrentlyContainsOneWishListNoItems() {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 30, longitude: 20), addressDictionary: nil)
        let coffeePlaceThree = MKMapItem(placemark: placemark)
        coffeePlaceThree.name = "coffee place for test"
        
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: coffeePlaceThree, wishListPositionIndex: 0)
        // returns the wishliststore from the mock user defaults helper and the item is appended to the wish list at index 0 in that wish list store
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].title, "coffee place for test")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].coordinate.latitude, CLLocationDegrees(30))
    }
    
    func testSavePlaceOfInterest_storeAlreadyContainsItemToSave() {
        let coffeePlaceOne = MapAnnotationPoint(title: "coffee place one", subtitle: "1, the street", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), number: "1", streetAddress: "the street")
        let coffeePlaceTwo = MapAnnotationPoint(title: "coffee place two", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), number: "2", streetAddress: "the street")
        let coffeeWishList = WishList(name: "coffee wish list", items: [coffeePlaceOne, coffeePlaceTwo], description: "london coffee")
        wishListStore.wishLists = [coffeeWishList]
        
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), addressDictionary: nil)
        let coffeePlaceThree = MKMapItem(placemark: placemark)
        coffeePlaceThree.name = "coffee place two"
        // has the same name and subtitle as coffeePlaceTwo so shouldn't be added
        
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: coffeePlaceThree, wishListPositionIndex: 0)
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items.count, 2)
    }
}

