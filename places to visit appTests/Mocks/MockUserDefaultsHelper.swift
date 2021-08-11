//
//  MockUserDefaultsHelper.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 05/08/2021.
//

import Foundation
@testable import places_to_visit_app
import MapKit

class MockUserDefaultsHelper: UserDefaultsHelperProtocol {
    
    static var updateUserDefaultsWasCalled: Bool = false
    
    static func retrieveDataFromUserDefaults(userDefaults: UserDefaultsProtocol) -> WishListStore {
        let coffeePlaceOne = MapAnnotationPoint(title: "coffee place one", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 30, longitude: 30), number: "1", streetAddress: "the street")
        let coffeeWishList = WishList(name: "test coffee list", items: [coffeePlaceOne], description: "chill coffee shops in london")
        return WishListStore(wishLists: [coffeeWishList])
    }
    
    static func updateUserDefaults(userDefaults: UserDefaultsProtocol, wishListStore: WishListStore) {
        self.updateUserDefaultsWasCalled = true
    }
    
    
}
