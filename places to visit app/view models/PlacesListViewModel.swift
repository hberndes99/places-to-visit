//
//  PlacesListViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 29/07/2021.
//

import Foundation

class PlacesListViewModel {
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
    
    
}
