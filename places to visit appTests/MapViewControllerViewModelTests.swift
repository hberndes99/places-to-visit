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
        mockUserDefaultsHelper = nil
    }

    func testRetrieveData() {
        mapViewControllerViewModel.retrieveData()
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].name, "test coffee list")
    }
    
    func testRetrieveData_filterInPLaceTrue() {
        mapViewControllerViewModel.applyFiltersToMap(filterList: ["test coffee list"])
        mapViewControllerViewModel.retrieveData()
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].name, "test coffee list")
    }
    
    func testSavePlaceOfInterestToUserDefaults() {
        mapViewControllerViewModel.savePlaceOfInterestToUserDefaults()
        
        XCTAssertTrue(mockUserDefaultsHelper.updateUserDefaultsWasCalled)
    }
    
    
    func testSavePlaceOfInterest_storeCurrentlyContainsOneWishListNoItems() {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 20), addressDictionary: nil)
        let coffeePlace = MKMapItem(placemark: placemark)
        coffeePlace.name = "coffee place for test"
        
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: coffeePlace, wishListPositionIndex: 0)
        // returns the wishliststore from the mock user defaults helper and the item is appended to the wish list at index 0 in that wish list store
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].name, "test coffee list")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].title, "coffee place one")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[1].title, "coffee place for test")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].coordinate.latitude, CLLocationDegrees(30))
    }
    
    func testSavePlaceOfInterest_storeAlreadyContainsItemToSave() {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), addressDictionary: nil)
        let coffeePlaceTwo = MKMapItem(placemark: placemark)
        coffeePlaceTwo.name = "coffee place one"
        // has the same name and subtitle as coffeePlaceTwo so shouldn't be added
        
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: coffeePlaceTwo, wishListPositionIndex: 0)
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].title, "coffee place one")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].title, "coffee place one")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].coordinate.latitude, CLLocationDegrees(30))
    }
    
    
    func testSavePlaceOfInterest_differentNameSameAddress() {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 30, longitude: 20), addressDictionary: nil)
        let coffeePlace = MKMapItem(placemark: placemark)
        coffeePlace.name = "coffee place that is different"
        
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: coffeePlace, wishListPositionIndex: 0)
        // returns the wishliststore from the mock user defaults helper and the item is appended to the wish list at index 0 in that wish list store
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].name, "test coffee list")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].title, "coffee place one")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[1].title, "coffee place that is different")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].coordinate.latitude, CLLocationDegrees(30))
    }
    
    func testApplyFiltersToMap() {
        
        // set wish list store
        let coffeePlaceOne = MapAnnotationPoint(title: "coffee place one", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 30, longitude: 30), number: "1", streetAddress: "the street")
        let coffeePlaceTwo = MapAnnotationPoint(title: "coffee place two", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 30, longitude: 30), number: "1", streetAddress: "the street")
        let coffeeWishList = WishList(name: "test coffee list", items: [coffeePlaceOne, coffeePlaceTwo], description: "chill coffee shops in london")
        let restaurantOne = MapAnnotationPoint(title: "restaurant one", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 30, longitude: 30), number: "1", streetAddress: "the street")
        let restaurantWishList = WishList(name: "test restuarant list", items: [restaurantOne], description: "cheap restaurants")
        
        mapViewControllerViewModel.wishListStore.wishLists = [coffeeWishList, restaurantWishList]
        mapViewControllerViewModel.applyFiltersToMap(filterList: ["test restuarant list"])
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 1)
        XCTAssertTrue(mapViewControllerViewModel.filteringInPlace)
    }
    
    func testClearFilters() {
        mapViewControllerViewModel.clearFilters()
        
        XCTAssertFalse(mapViewControllerViewModel.filteringInPlace)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].name, "test coffee list")
    }
}

