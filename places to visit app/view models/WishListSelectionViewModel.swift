//
//  WishListSelectionViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 30/07/2021.
//

import Foundation

class WishListSelectionViewModel {
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
    
    // same
    func updateUserDefaults() {
        userDefaultsHelper.updateUserDefaults(userDefaults: userDefaults, wishListStore: self.wishListStore)
    }
    
    func saveNewWishList(name: String, description: String) {
        let newWishList = WishList(name: name, items: [], description: description)
        if WishListStoreHelper.checkForDuplication(itemToCheckFor: newWishList, listToCheckThrough: wishListStore.wishLists, propertiesToCheckAgainst: [\WishList.name]) {
            return
        }
        wishListStore.wishLists.append(newWishList)
        updateUserDefaults()
    }
}
