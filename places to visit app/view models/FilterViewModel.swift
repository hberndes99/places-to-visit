//
//  FilterViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 11/08/2021.
//

import Foundation

class FilterViewModel {
    var wishListStore: WishListStore
    var userDefaults: UserDefaultsProtocol
    var userDefaultsHelper: UserDefaultsHelperProtocol.Type
    
    init(wishListStore: WishListStore,
         userDefaults: UserDefaultsProtocol = UserDefaults.standard,
         userDefaultsHelper: UserDefaultsHelperProtocol.Type = UserDefaultsHelper.self) {
        self.wishListStore = wishListStore
        self.userDefaults = userDefaults
        self.userDefaultsHelper = userDefaultsHelper
    }
    
    // should be private
    func retrieveData() {
        wishListStore = userDefaultsHelper.retrieveDataFromUserDefaults(userDefaults: userDefaults)
    }
}
