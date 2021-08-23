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
    
    func updateUserDefaults() {
        userDefaultsHelper.updateUserDefaults(userDefaults: userDefaults, wishListStore: self.wishListStore)
    }
    
    func deletePlaceOfInterest(at position: Int, from wishListPosition: Int) {
        if wishListStore.wishLists.count > wishListPosition, wishListStore.wishLists[wishListPosition].items.count > position {
            let wishListToDeleteFrom = wishListStore.wishLists[wishListPosition]
            wishListToDeleteFrom.items.remove(at: position)
            updateUserDefaults()
        }
    }
    
    func deleteWishList(at position: Int) {
        if wishListStore.wishLists.count > position {
            wishListStore.wishLists.remove(at: position)
            updateUserDefaults()
        }
    }
}
