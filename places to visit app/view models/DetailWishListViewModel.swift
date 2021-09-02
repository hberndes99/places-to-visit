//
//  DetailWishListViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 23/08/2021.
//

import Foundation

protocol DetailWishListViewModelDelegate: AnyObject {
    func updateDetailView()
}

class DetailWishListViewModel {
    var wishListStore: [WishList] = [WishList]()
    var userDefaults: UserDefaultsProtocol
    var userDefaultsHelper: UserDefaultsHelperProtocol.Type
    weak var detailWishListViewModelDelegate: DetailWishListViewModelDelegate?
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard,
         userDefaultsHelper: UserDefaultsHelperProtocol.Type = UserDefaultsHelper.self) {
        self.userDefaults = userDefaults
        self.userDefaultsHelper = userDefaultsHelper
    }
    
    // should be private
    func retrieveData() {
        NetworkManager.getData() { [weak self] wishLists in
            self?.wishListStore = wishLists
            self?.detailWishListViewModelDelegate?.updateDetailView()
        }
        //wishListStore = userDefaultsHelper.retrieveDataFromUserDefaults(userDefaults: userDefaults)
    }
    
    //func updateUserDefaults() {
        //userDefaultsHelper.updateUserDefaults(userDefaults: userDefaults, wishListStore: self.wishListStore)
    //}
    
    func deletePlaceOfInterest(at position: Int, from wishListPosition: Int) {
        //if wishListStore.count > wishListPosition, wishListStore.[wishListPosition].items.count > position {
        //    let wishListToDeleteFrom = wishListStore[wishListPosition]
         //   wishListToDeleteFrom.items.remove(at: position)
         //   updateUserDefaults()
        //}
        let mapPointToDelete = wishListStore[wishListPosition].items[position]
        if let id = mapPointToDelete.id {
            NetworkManager.deleteMapPoint(id: id)
            self.wishListStore[wishListPosition].items.remove(at: position)

        }
        
    }
    
    func deleteWishList(at position: Int) {
        
        if wishListStore.count > position {
            if let id = wishListStore[position].id {
                NetworkManager.deleteWishList(id: id)
            }
            wishListStore.remove(at: position)
            
        }
 
    }
}
