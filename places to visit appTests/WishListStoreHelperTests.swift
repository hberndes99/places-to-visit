//
//  WishListStoreHelperTests.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 11/08/2021.
//


import XCTest
@testable import places_to_visit_app
import MapKit

class WishListStoreHelperTests: XCTestCase {
    
    var wishList: WishList!
    
    override func setUpWithError() throws {
        let coffeePlaceOne = MapAnnotationPoint(id: 1, title: "coffee place one", subtitle: "1, the street", longitude: "50", latitude: "50", number: "1", streetAddress: "the street", wishList: 1)
        let coffeePlaceTwo = MapAnnotationPoint(id: 2, title: "coffee place two", subtitle: "", longitude: "50", latitude: "50", number: "2", streetAddress: "the street", wishList: 1)
        wishList = WishList(id: 1, name: "coffee", items: [coffeePlaceOne, coffeePlaceTwo], description: "coffee in london")
    }

    override func tearDownWithError() throws {
        wishList = nil
    }
    
    func testWishListStoreHelper_noDuplication() {
        let coffeePlaceThree = MapAnnotationPoint(id: 3, title: "coffee place three", subtitle: "10, the hill", longitude: "50", latitude: "50", number: "2", streetAddress: "the hill", wishList: 1)
        let result = WishListStoreHelper.checkForDuplication(itemToCheckFor: coffeePlaceThree, listToCheckThrough: wishList.items, propertiesToCheckAgainst: [\MapAnnotationPoint.title, \MapAnnotationPoint.subtitle])
        
        XCTAssertFalse(result)
    }

    func testWishListStoreHelper_duplicationPresent() {
        let coffeePlaceThree = MapAnnotationPoint(id: 3, title: "coffee place two", subtitle: "10, the hill", longitude: "50", latitude: "50", number: "2", streetAddress: "the hill", wishList: 1)
        let result = WishListStoreHelper.checkForDuplication(itemToCheckFor: coffeePlaceThree, listToCheckThrough: wishList.items, propertiesToCheckAgainst: [\MapAnnotationPoint.title, \MapAnnotationPoint.subtitle])
        
        XCTAssertTrue(result)
    }
    

}

