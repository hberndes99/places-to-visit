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
    var mockMapViewControllerViewModelDelegate: MockMapViewControllerViewModelDelegate!
    var coffeePlaceOne: MapAnnotationPoint!
    var coffeePlaceTwo: MapAnnotationPoint!
    var coffeeWishList: WishList!
    var restaurantOne: MapAnnotationPoint!
    var restaurantWishList: WishList!
    var currentLocation: CLLocation!
    
    override func setUpWithError() throws {
        wishListStore = WishListStore(wishLists: [])
        mockUserDefaults = MockUserDefaults()
        mockUserDefaultsHelper = MockUserDefaultsHelper.self
        mockMapViewControllerViewModelDelegate = MockMapViewControllerViewModelDelegate()
    
       mapViewControllerViewModel = MapViewControllerViewModel(
            wishListStore: wishListStore,
            userDefaults: mockUserDefaults,
            userDefaultsHelper: mockUserDefaultsHelper)
        mapViewControllerViewModel.mapViewControllerViewModelDelegate = mockMapViewControllerViewModelDelegate
        
        coffeePlaceOne = MapAnnotationPoint(title: "coffee place one", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 50, longitude: 50), number: "1", streetAddress: "the street")
        coffeePlaceTwo = MapAnnotationPoint(title: "coffee place two", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 30, longitude: 30), number: "1", streetAddress: "the street")
        coffeeWishList = WishList(name: "test coffee list", items: [coffeePlaceOne, coffeePlaceTwo], description: "chill coffee shops in london")
        restaurantOne = MapAnnotationPoint(title: "restaurant one", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 50, longitude: 50), number: "1", streetAddress: "the street")
        restaurantWishList = WishList(name: "test restuarant list", items: [restaurantOne], description: "cheap restaurants")
        
        currentLocation = CLLocation(latitude: CLLocationDegrees(30), longitude: CLLocationDegrees(30))
    }

    override func tearDownWithError() throws {
        mapViewControllerViewModel = nil
        wishListStore = nil
        mockUserDefaults = nil
        mockUserDefaultsHelper = nil
    }
    
    func testSetUserLocation() {
        mapViewControllerViewModel.setUserLocation(currentLocation: currentLocation)
        XCTAssertEqual(mapViewControllerViewModel.userCurrentLocation, currentLocation)
    }

    func testRetrieveData_noFiltering() {
        mapViewControllerViewModel.retrieveData()
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].name, "test coffee list")
    }
    
    func testRetrieveData_stringFilterInPLaceTrue() {
        mapViewControllerViewModel.applyFiltersToMap(filterList: ["test coffee list"], distance: nil)
        mapViewControllerViewModel.retrieveData()
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].name, "test coffee list")
    }
    
    func testRetrieveData_distanceFilterInPlace() {
        mapViewControllerViewModel.setUserLocation(currentLocation: currentLocation)
        mapViewControllerViewModel.applyFiltersToMap(filterList: nil, distance: 1)
        mapViewControllerViewModel.retrieveData()
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items.count, 0)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[1].items.count, 1)
    }
    
    func testSavePlaceOfInterestToUserDefaults() {
        mapViewControllerViewModel.savePlaceOfInterestToUserDefaults()
        
        XCTAssertTrue(mockUserDefaultsHelper.updateUserDefaultsWasCalled)
    }
    
    
    func testSavePlaceOfInterest() {
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
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].coordinate.latitude, CLLocationDegrees(50))
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
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].coordinate.latitude, CLLocationDegrees(50))
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
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].coordinate.latitude, CLLocationDegrees(50))
    }
    
    func testApplyFiltersToMap_justWishListFilter() {
        mapViewControllerViewModel.setUserLocation(currentLocation: currentLocation)
        
        mapViewControllerViewModel.wishListStore.wishLists = [coffeeWishList, restaurantWishList]
        mapViewControllerViewModel.applyFiltersToMap(filterList: ["test restuarant list"], distance: nil)
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items.count, 1)
        XCTAssertTrue(mapViewControllerViewModel.filteringInPlace)
    }
    
    func testApplyFiltersToMap_justDistanceFilter() {
        mapViewControllerViewModel.wishListStore.wishLists = [coffeeWishList, restaurantWishList]
        mapViewControllerViewModel.setUserLocation(currentLocation: currentLocation)
        
        let filterDistance = 1
        
        mapViewControllerViewModel.applyFiltersToMap(filterList: nil, distance: filterDistance)
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].title, "coffee place two")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[1].items.count, 0)
        XCTAssertTrue(mapViewControllerViewModel.filteringInPlace)
    }
    
    
    func testApplyFiltersToMap_distanceAndWishListFilter() {
        mapViewControllerViewModel.wishListStore.wishLists = [coffeeWishList, restaurantWishList]
        mapViewControllerViewModel.setUserLocation(currentLocation: currentLocation)
        
        let filterDistance = 1
        
        mapViewControllerViewModel.applyFiltersToMap(filterList: ["test coffee list"], distance: filterDistance)
        // this was saying it should be 2 before
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].title, "coffee place two")
        //XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[1].items.count, 0)
        XCTAssertTrue(mapViewControllerViewModel.filteringInPlace)
        XCTAssertTrue(mockMapViewControllerViewModelDelegate.updateMapWithFiltersWasCalled)
    }
    
    func testClearFilters() {
        mapViewControllerViewModel.clearFilters()
        
        XCTAssertFalse(mapViewControllerViewModel.filteringInPlace)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].name, "test coffee list")
    }
}

class MockMapViewControllerViewModelDelegate: MapViewControllerViewModelDelegate {
    var updateMapWithFiltersWasCalled: Bool = false
    func updateMapWithFilters() {
        updateMapWithFiltersWasCalled = true
    }
}
