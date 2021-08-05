//
//  UserDefaultsHelper.swift
//  places to visit app
//
//  Created by Harriette Berndes on 05/08/2021.
//

import Foundation

class UserDefaultsHelper {

    static func retrieveDataFromUserDefaults(userDefaults: UserDefaultsProtocol = UserDefaults.standard) -> WishListStore {
        if let existingData = userDefaults.data(forKey: Constants.savedPlaces) {
            let jsonDecoder = JSONDecoder()
            if let decodedData = try? jsonDecoder.decode(WishListStore.self, from: existingData) {
                return decodedData
            }
        }
        return WishListStore(wishLists: [])
    }
    
    static func updateUserDefaults(userDefaults: UserDefaultsProtocol = UserDefaults.standard, wishListStore: WishListStore) {
        let jsonEncoder = JSONEncoder()
        if let encodedPlaces = try? jsonEncoder.encode(wishListStore) {
            userDefaults.setValue(encodedPlaces, forKey: Constants.savedPlaces)
        }
    }
}


protocol UserDefaultsHelperProtocol {
    static func retrieveDataFromUserDefaults(userDefaults: UserDefaultsProtocol) -> WishListStore
    
    static func updateUserDefaults(userDefaults: UserDefaultsProtocol, wishListStore: WishListStore)
}

extension UserDefaultsHelper: UserDefaultsHelperProtocol {
    
}
