//
//  MockUserDefaultsHelper.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 05/08/2021.
//

import Foundation
@testable import places_to_visit_app

class MockUserDefaultsHelper: UserDefaultsHelperProtocol {
    
    static var updateUserDefaultsWasCalled: Bool = false
    
    static func retrieveDataFromUserDefaults(userDefaults: UserDefaultsProtocol) -> WishListStore {
        let coffeeWishList = WishList(name: "test coffee list", items: [], description: "chill coffee shops in london")
        return WishListStore(wishLists: [coffeeWishList])
    }
    
    static func updateUserDefaults(userDefaults: UserDefaultsProtocol, wishListStore: WishListStore) {
        self.updateUserDefaultsWasCalled = true
    }
    
    
}
