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
        if let oldMapStore = userDefaults.data(forKey: Constants.savedPlaces) {
            let jsonDecoder = JSONDecoder()
            if let oldMapStoreDecoded = try? jsonDecoder.decode(WishListStore.self, from: oldMapStore) {
                wishListStore = oldMapStoreDecoded
            }
        }
    }
    
    private func updateUserDefaults() {
        let jsonEncoder = JSONEncoder()
        if let encodedUpdatedPlaces = try? jsonEncoder.encode(wishListStore) {
            userDefaults.setValue(encodedUpdatedPlaces, forKey: Constants.savedPlaces)
        }
    }
    
    func deletePlaceOfInterest(at position: Int, from wishListPosition: Int) {
        // should I have a check in here
        // might need to pass in wishListPosition
        var wishListToDeleteFrom = wishListStore.wishLists[wishListPosition]
        wishListToDeleteFrom.items.remove(at: position)
        updateUserDefaults()
        
        //if position < mapAnnotationsStore.mapAnnotationPoints.count {
        //    mapAnnotationsStore.mapAnnotationPoints.remove(at: position)
        //    updateUserDefaults()
        //}
    }
}
