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
    var mockNetworkManager: MockNetworkManager!
    var mockMapViewControllerViewModelDelegate: MockMapViewControllerViewModelDelegate!
    var coffeePlaceOne: MapAnnotationPoint!
    var coffeePlaceTwo: MapAnnotationPoint!
    var coffeeWishList: WishList!
    var restaurantOne: MapAnnotationPoint!
    var restaurantWishList: WishList!
    var currentLocation: CLLocation!
    
    override func setUpWithError() throws {

        mockMapViewControllerViewModelDelegate = MockMapViewControllerViewModelDelegate()
        mockNetworkManager = MockNetworkManager()
       mapViewControllerViewModel = MapViewControllerViewModel(networkManager: mockNetworkManager)
        mapViewControllerViewModel.mapViewControllerViewModelDelegate = mockMapViewControllerViewModelDelegate
        
        //coffeePlaceOne = MapAnnotationPoint(id: 1, title: "coffee place one", subtitle: "1, the street", longitude: "50", latitude: "50", number: "1", streetAddress: "the street", wishList: 1)
        
        //coffeeWishList = WishList(id: 1, name: "coffee wish list", items: [], description: "chill coffee")
        
        currentLocation = CLLocation(latitude: CLLocationDegrees(30), longitude: CLLocationDegrees(30))
    }

    override func tearDownWithError() throws {
        mapViewControllerViewModel = nil

    }
    
    func testSetUserLocation() {
        mapViewControllerViewModel.setUserLocation(currentLocation: currentLocation)
        XCTAssertEqual(mapViewControllerViewModel.userCurrentLocation, currentLocation)
    }

    
    func testRetrieveData_noFiltering() {
        mapViewControllerViewModel.retrieveData()
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore[0].name, "coffee wish list")
    }
 
    
    func testRetrieveData_stringFilterInPLaceTrue() {
        mapViewControllerViewModel.applyFiltersToMap(filterList: ["restaurant wish list"], distance: nil)
        mapViewControllerViewModel.retrieveData()
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore[0].name, "restaurant wish list")
    }
 
    
    func testRetrieveData_distanceFilterInPlace() {
        mapViewControllerViewModel.setUserLocation(currentLocation: currentLocation)
        mapViewControllerViewModel.applyFiltersToMap(filterList: nil, distance: 1)
        mapViewControllerViewModel.retrieveData()
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore[0].items.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore[0].items[0].title, "coffee place two")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore[1].items.count, 0)
    }
    

    
    //TODO: see if this code is necessary
    func testSavePlaceOfInterest() {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 20), addressDictionary: nil)
        let coffeePlace = MKMapItem(placemark: placemark)
        coffeePlace.name = "coffee place for saving test"
        
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: coffeePlace, wishListId: 1)
       // the id part/index part is the issue
        //XCTAssertEqual(mapViewControllerViewModel.wishListStore[0].items.count, 2)

    }
    
    //TODO: fix this
    func testSavePlaceOfInterest_storeAlreadyContainsItemToSave() {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), addressDictionary: nil)
        let coffeePlaceTest = MKMapItem(placemark: placemark)
        coffeePlaceTest.name = "coffee place one"
        // has the same name and subtitle as coffeePlaceOne so shouldn't be added
        
        mapViewControllerViewModel.retrieveData()
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: coffeePlaceTest, wishListId: 1)
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore[0].items.count, 2)
        
       
    }
    
    /*
    func testSavePlaceOfInterest_differentNameSameAddress() {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 30, longitude: 20), addressDictionary: nil)
        let coffeePlace = MKMapItem(placemark: placemark)
        coffeePlace.name = "coffee place that is different"
        
        mapViewControllerViewModel.savePlaceOfInterest(placeOfInterest: coffeePlace, wishListId: 0)
        // returns the wishliststore from the mock user defaults helper and the item is appended to the wish list at index 0 in that wish list store
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].name, "test coffee list")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].title, "coffee place one")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[1].title, "coffee place that is different")
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.wishLists[0].items[0].coordinate.latitude, CLLocationDegrees(50))

    }
     */
    
    func testApplyFiltersToMap_justWishListFilter() {
        mapViewControllerViewModel.setUserLocation(currentLocation: currentLocation)
        
        mapViewControllerViewModel.retrieveData()
        mapViewControllerViewModel.applyFiltersToMap(filterList: ["coffee wish list"], distance: nil)
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore[0].items.count, 2)
        XCTAssertTrue(mapViewControllerViewModel.filteringInPlace)
    }
    
    func testApplyFiltersToMap_justDistanceFilter() {
        mapViewControllerViewModel.retrieveData()
        mapViewControllerViewModel.setUserLocation(currentLocation: currentLocation)
        
        let filterDistance = 1
        
        mapViewControllerViewModel.applyFiltersToMap(filterList: nil, distance: filterDistance)
        
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore[0].items.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore[0].items[0].title, "coffee place two")
        XCTAssertTrue(mapViewControllerViewModel.filteringInPlace)
 
    }
    
    
    func testApplyFiltersToMap_distanceAndWishListFilter() {
        mapViewControllerViewModel.retrieveData()
        mapViewControllerViewModel.setUserLocation(currentLocation: currentLocation)
        
        let filterDistance = 1
        
        mapViewControllerViewModel.applyFiltersToMap(filterList: ["coffee wish list"], distance: filterDistance)
        // this was saying it should be 2 before
      
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore[0].items.count, 1)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore[0].items[0].title, "coffee place two")
        XCTAssertTrue(mapViewControllerViewModel.filteringInPlace)
        XCTAssertTrue(mockMapViewControllerViewModelDelegate.updateMapWithFiltersWasCalled)
    }
    
    func testClearFilters() {
        mapViewControllerViewModel.clearFilters()
        XCTAssertFalse(mapViewControllerViewModel.filteringInPlace)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore.count, 2)
        XCTAssertEqual(mapViewControllerViewModel.wishListStore[0].name, "coffee wish list")
 
    }
}

class MockMapViewControllerViewModelDelegate: MapViewControllerViewModelDelegate {
    func loadMapAnnotations() {
        //
    }
    
    var updateMapWithFiltersWasCalled: Bool = false
    func updateMapWithFilters() {
        updateMapWithFiltersWasCalled = true
    }
}
