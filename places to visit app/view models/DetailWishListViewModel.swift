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
    private(set) var wishListStore: [WishList] = [WishList]()
    private var userDefaults: UserDefaultsProtocol
    private var userDefaultsHelper: UserDefaultsHelperProtocol.Type
    weak var detailWishListViewModelDelegate: DetailWishListViewModelDelegate?
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard,
         userDefaultsHelper: UserDefaultsHelperProtocol.Type = UserDefaultsHelper.self) {
        self.userDefaults = userDefaults
        self.userDefaultsHelper = userDefaultsHelper
    }
    
    func retrieveData() {
        NetworkManager.getData() { [weak self] wishLists in
            self?.wishListStore = wishLists
            self?.detailWishListViewModelDelegate?.updateDetailView()
        }
    }
    
    func deletePlaceOfInterest(at position: Int, from wishListPosition: Int) {
        let mapPointToDelete = wishListStore[wishListPosition].items[position]
        if let id = mapPointToDelete.id {
            NetworkManager.deleteItem(endpoint: "places/wishlists/mappoints/", id: id)
            self.wishListStore[wishListPosition].items.remove(at: position)
        }
    }
    
    func deleteWishList(at position: Int, completion: @escaping () -> ()) {
        if wishListStore.count > position {
            if let id = wishListStore[position].id {
                NetworkManager.deleteItem(endpoint: "places/wishlists/", id: id)
                completion()
            }
            wishListStore.remove(at: position)
        }
    }
}
