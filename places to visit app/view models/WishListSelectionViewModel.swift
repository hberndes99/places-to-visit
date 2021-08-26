//
//  WishListSelectionViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 30/07/2021.
//

import Foundation

class WishListSelectionViewModel {
    var wishListStore: [WishList] = [WishList]()
    var userDefaults: UserDefaultsProtocol
    var userDefaultsHelper: UserDefaultsHelperProtocol.Type
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard,
         userDefaultsHelper: UserDefaultsHelperProtocol.Type = UserDefaultsHelper.self) {
        self.userDefaults = userDefaults
        self.userDefaultsHelper = userDefaultsHelper
    }
    
    // should be private
    func retrieveData() {
        NetworkManager.getData() { [weak self] wishLists in
            self?.wishListStore = wishLists
        }
        //wishListStore = userDefaultsHelper.retrieveDataFromUserDefaults(userDefaults: userDefaults)
    }
    
    // same
    func updateUserDefaults() {
        //userDefaultsHelper.updateUserDefaults(userDefaults: userDefaults, wishListStore: self.wishListStore)
    }
    
    func saveNewWishList(name: String, description: String) {
        let newWishList = WishList(id: 0, name: name, items: [], description: description)
        if WishListStoreHelper.checkForDuplication(itemToCheckFor: newWishList, listToCheckThrough: wishListStore, propertiesToCheckAgainst: [\WishList.name]) {
            return
        }
        wishListStore.append(newWishList)
        updateUserDefaults()
    }
}
