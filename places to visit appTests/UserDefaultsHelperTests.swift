//
//  UserDefaultsHelperTests.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 05/08/2021.
//

import XCTest
@testable import places_to_visit_app
import MapKit

/*
 

class UserDefaultsHelperTests: XCTestCase {

    var mockUserDefaults: MockUserDefaults!
    var wishListStore: WishListStore!
    
    override func setUpWithError() throws {
        mockUserDefaults = MockUserDefaults()
        
        let pointOfInterestOne = MapAnnotationPoint(title: "coffee place", subtitle: "1, high street", coordinate: CLLocationCoordinate2D.init(latitude: 0.2, longitude: 0.1), number: "1", streetAddress: "high street")
        let coffeeWishList = WishList(name: "coffee wish list", items: [pointOfInterestOne], description: "london coffee")
        wishListStore = WishListStore(wishLists: [coffeeWishList])
    }

    override func tearDownWithError() throws {
        mockUserDefaults = nil
        wishListStore = nil
    }

    
    func testRetrieveDataFromUserDefaults_existingData() {
        
        let jsonEncoder = JSONEncoder()
        guard let encodedData = try? jsonEncoder.encode(wishListStore) else {
            XCTFail()
            return
        }
        
        mockUserDefaults.saved["savedPlaces"] = encodedData
        
        let data = UserDefaultsHelper.retrieveDataFromUserDefaults(userDefaults: mockUserDefaults)
        
        XCTAssertEqual(data.wishLists.count, 1)
        XCTAssertTrue(mockUserDefaults.dataWasCalled)
    }

    func testRetrieveDataFromUserDefaults_noExistingData() {
        let data = UserDefaultsHelper.retrieveDataFromUserDefaults(userDefaults: mockUserDefaults)
        
        XCTAssertFalse(mockUserDefaults.dataWasCalled)
        XCTAssertEqual(data.wishLists.count, 0)
    }
    
    func testUpdateUserDefaults_currentlyEmpty() {
        
        UserDefaultsHelper.updateUserDefaults(userDefaults: mockUserDefaults, wishListStore: wishListStore)
        
        let jsonDecoder = JSONDecoder()
        guard let decodedSetData = try? jsonDecoder.decode(WishListStore.self, from: mockUserDefaults.savedBySetValue["savedPlaces"] as! Data) else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(mockUserDefaults.setValueWasCalled)
        XCTAssertEqual(decodedSetData.wishLists.count, 1)
        XCTAssertEqual(decodedSetData.wishLists[0].items[0].title, "coffee place")
    }
    
    func testUpdateUserDefaults_notCurrentlyEmpty() {
        let jsonEncoder = JSONEncoder()
        guard let encodedData = try? jsonEncoder.encode(wishListStore) else {
            XCTFail()
            return
        }
        mockUserDefaults.savedBySetValue["savedPlaces"] = encodedData
        
        let secondWishList = WishList(name: "restaurants list", items: [], description: "")
        wishListStore.wishLists.append(secondWishList)
        
        UserDefaultsHelper.updateUserDefaults(userDefaults: mockUserDefaults, wishListStore: wishListStore)
        
        let jsonDecoder = JSONDecoder()
        guard let decodedSetData = try? jsonDecoder.decode(WishListStore.self, from: mockUserDefaults.savedBySetValue["savedPlaces"] as! Data) else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(mockUserDefaults.setValueWasCalled)
        XCTAssertEqual(decodedSetData.wishLists.count, 2)
    }
    
}

 */
