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
        if let existingData = userDefaults.data(forKey: Constants.savedPlaces) {
            let jsonDecoder = JSONDecoder()
            if let decodedData = try? jsonDecoder.decode(WishListStore.self, from: existingData) {
                wishListStore = decodedData
            }
        }
    }
    
    private func updateUserDefaults() {
        let jsonEncoder = JSONEncoder()
        if let encodedPlaces = try? jsonEncoder.encode(wishListStore) {
            userDefaults.setValue(encodedPlaces, forKey: Constants.savedPlaces)
        }
    }
    
    func saveNewWishList(name: String, description: String) {
        // trim name
        
        // instantiate new wish list
        let newWishList = WishList(name: name, items: [])
        // append to the store
        wishListStore.wishLists.append(newWishList)
        updateUserDefaults()
    }
}
