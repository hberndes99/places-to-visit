//
//  DetailWishListViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 23/08/2021.
//

import Foundation

class DetailWishListViewModel {
    var wishListStore: WishListStore = WishListStore(wishLists: [])
    var userDefaults: UserDefaultsProtocol
    var userDefaultsHelper: UserDefaultsHelperProtocol.Type
    
    init(
         userDefaults: UserDefaultsProtocol = UserDefaults.standard,
         userDefaultsHelper: UserDefaultsHelperProtocol.Type = UserDefaultsHelper.self) {
        self.userDefaults = userDefaults
        self.userDefaultsHelper = userDefaultsHelper
    }
    
    // should be private
    func retrieveData() {
        wishListStore = userDefaultsHelper.retrieveDataFromUserDefaults(userDefaults: userDefaults)
    }
    
}
