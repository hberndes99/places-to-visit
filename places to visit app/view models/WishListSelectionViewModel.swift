//
//  WishListSelectionViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 30/07/2021.
//

import Foundation

class WishListSelectionViewModel {
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
    
    func saveNewWishList(name: String, description: String) {
        for wishList in wishListStore.wishLists {
            if wishList.name == name {
                print("wish lsit with the same name already exists")
                return
            }
        }
        let newWishList = WishList(name: name, items: [], description: description)
        wishListStore.wishLists.append(newWishList)
        updateUserDefaults()
    }
}
