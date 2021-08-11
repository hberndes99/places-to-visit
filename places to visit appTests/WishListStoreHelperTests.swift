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
        let coffeePlaceOne = MapAnnotationPoint(title: "coffee place one", subtitle: "1, the street", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), number: "1", streetAddress: "the street")
        let coffeePlaceTwo = MapAnnotationPoint(title: "coffee place two", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), number: "2", streetAddress: "the street")
        wishList = WishList(name: "coffee", items: [coffeePlaceOne, coffeePlaceTwo], description: "coffee in london")
    }

    override func tearDownWithError() throws {
        wishList = nil
    }
    
    func testWishListStoreHelper_noDuplication() {
        let coffeePlaceThree = MapAnnotationPoint(title: "coffee place three", subtitle: "10, the hill", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), number: "2", streetAddress: "the hill")
        let result = WishListStoreHelper.checkForDuplication(itemToCheckFor: coffeePlaceThree, listToCheckThrough: wishList.items, propertiesToCheckAgainst: [\MapAnnotationPoint.title, \MapAnnotationPoint.subtitle])
        
        XCTAssertFalse(result)
    }

    func testWishListStoreHelper_duplicationPresent() {
        let coffeePlaceThree = MapAnnotationPoint(title: "coffee place two", subtitle: "10, the hill", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), number: "2", streetAddress: "the hill")
        let result = WishListStoreHelper.checkForDuplication(itemToCheckFor: coffeePlaceThree, listToCheckThrough: wishList.items, propertiesToCheckAgainst: [\MapAnnotationPoint.title, \MapAnnotationPoint.subtitle])
        
        XCTAssertTrue(result)
    }
    

}
