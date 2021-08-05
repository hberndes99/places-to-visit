//
//  PlacesListViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 29/07/2021.
//

import Foundation

class PlacesListViewModel {
    var wishListStore: WishListStore
    private var userDefaults: UserDefaultsProtocol
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard, wishListStore: WishListStore) {
        self.wishListStore = wishListStore
        self.userDefaults = userDefaults
    }
    
    func retrieveData() {
        wishListStore = UserDefaultsHelper.retrieveDataFromUserDefaults()
    }
    
    private func updateUserDefaults() {
        UserDefaultsHelper.updateUserDefaults(wishListStore: self.wishListStore)
    }
    
    func deletePlaceOfInterest(at position: Int, from wishListPosition: Int) {
        if wishListStore.wishLists.count > wishListPosition, wishListStore.wishLists[wishListPosition].items.count > position {
            let wishListToDeleteFrom = wishListStore.wishLists[wishListPosition]
            wishListToDeleteFrom.items.remove(at: position)
            updateUserDefaults()
        }
    }
}
