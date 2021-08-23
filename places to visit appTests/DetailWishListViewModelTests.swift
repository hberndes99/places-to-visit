//
//  DetailWishListViewModelTests.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 23/08/2021.
//

import XCTest
@testable import places_to_visit_app
import MapKit

class DetailWishListViewModelTests: XCTestCase {
    var detailWishListViewModel: DetailWishListViewModel!
    var mockUserDefaults: MockUserDefaults!
    var mockUserDefaultsHelper: MockUserDefaultsHelper.Type!
    
    override func setUpWithError() throws {
        mockUserDefaults = MockUserDefaults()
        mockUserDefaultsHelper = MockUserDefaultsHelper.self
        
        detailWishListViewModel = DetailWishListViewModel(userDefaults: mockUserDefaults, userDefaultsHelper: mockUserDefaultsHelper)
        
        let coffeePlaceOne = MapAnnotationPoint(title: "coffee place one", subtitle: "1, the street", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), number: "1", streetAddress: "the street")
        let coffeePlaceTwo = MapAnnotationPoint(title: "coffee place two", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), number: "2", streetAddress: "the street")
        let coffeeWishList = WishList(name: "coffee", items: [coffeePlaceOne, coffeePlaceTwo], description: "coffee in london")
        let restaurantWishList = WishList(name: "restaurant", items: [], description: "restaurants in london")
        detailWishListViewModel.wishListStore.wishLists = [coffeeWishList, restaurantWishList]
        
    }

    override func tearDownWithError() throws {
        detailWishListViewModel = nil
        mockUserDefaults = nil
        mockUserDefaultsHelper = nil
    }
    
    func testRetrieveData() {
        detailWishListViewModel.retrieveData()
        
        XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists.count, 2)
        XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists[0].name, "test coffee list")
    }
    
    func testUpdateUserDefaults() {
        detailWishListViewModel.updateUserDefaults()
        XCTAssert(mockUserDefaultsHelper.updateUserDefaultsWasCalled)
    }

    func testDeletePlaceOfInterest() {
        detailWishListViewModel.deletePlaceOfInterest(at: 0, from: 0)
        
        XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists[0].items.count, 1)
        XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists[0].items[0].title, "coffee place two")
    }
    
    func testDeletePlaceOfInterest_outOfRange() {
        detailWishListViewModel.deletePlaceOfInterest(at: 3, from: 0)
        
        XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists[0].items.count, 2)
        XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists[0].items[0].title, "coffee place one")
    }
    
    func testDeleteWishList() {
        detailWishListViewModel.deleteWishList(at: 0)
        
        XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists.count, 1)
        XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists[0].name, "restaurant")
    }
    
    func testDeleteWishList_outOfRange() {
        detailWishListViewModel.deleteWishList(at: 2)
        
        XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists.count, 2)
        XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists[0].name, "coffee")
    }

}
