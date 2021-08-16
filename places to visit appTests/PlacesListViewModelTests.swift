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
    var mockUserDefaultsHelper: MockUserDefaultsHelper.Type!
    var pointOfInterestOne: MapAnnotationPoint!
    var pointOfInterestTwo: MapAnnotationPoint!
    var coffeeWishList: WishList!
    
    override func setUpWithError() throws {
        wishListStore = WishListStore(wishLists: [])
        mockUserDefaults = MockUserDefaults()
        mockUserDefaultsHelper = MockUserDefaultsHelper.self
        
        placesListViewModel = PlacesListViewModel(wishListStore: wishListStore, userDefaults: mockUserDefaults, userDefaultsHelper: mockUserDefaultsHelper)
        
        pointOfInterestOne = MapAnnotationPoint(title: "coffee place one", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1), number: "1", streetAddress: "high street")
        pointOfInterestTwo = MapAnnotationPoint(title: "coffee place two", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1), number: "1", streetAddress: "high street")
        
        coffeeWishList = WishList(name: "coffee wish list", items: [pointOfInterestOne, pointOfInterestTwo], description: "london coffee")
    }

    override func tearDownWithError() throws {
        wishListStore = nil
        placesListViewModel = nil
        mockUserDefaults = nil
        mockUserDefaultsHelper = nil
    }

    func testRetrieveData() {
        placesListViewModel.retrieveData()
        
        XCTAssertEqual(placesListViewModel.wishListStore.wishLists.count, 2)
        XCTAssertEqual(placesListViewModel.wishListStore.wishLists[0].name, "test coffee list")
    }
    
    func testUpdateUserDefaults() {
        placesListViewModel.updateUserDefaults()
        
        XCTAssertTrue(mockUserDefaultsHelper.updateUserDefaultsWasCalled)
        
    }
    
    func testDeletePlaceOfInterest() {
        placesListViewModel.wishListStore.wishLists = [coffeeWishList]
        placesListViewModel.deletePlaceOfInterest(at: 0, from: 0)
        
        XCTAssertEqual(placesListViewModel.wishListStore.wishLists.count, 1)
        XCTAssertEqual(placesListViewModel.wishListStore.wishLists[0].items.count, 1)
        XCTAssertEqual(placesListViewModel.wishListStore.wishLists[0].items[0].title, "coffee place two")
    }
    
    func testDeletePlaceOfInterest_dodgyCall() {
        placesListViewModel.wishListStore.wishLists = [coffeeWishList]
        placesListViewModel.deletePlaceOfInterest(at: 2, from: 0)
        
        XCTAssertEqual(placesListViewModel.wishListStore.wishLists[0].items.count, 2)
    }
    
}
