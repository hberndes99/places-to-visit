//
//  WishListSelectionViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 30/07/2021.
//

import Foundation

protocol WishListSelectionViewModelDelegate: AnyObject {
    func updateWishListList()
}

class WishListSelectionViewModel {
    private(set) var wishListStore: [WishList] = [WishList]()

    weak var wishListSelectionViewModelDelegate: WishListSelectionViewModelDelegate?
    var networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func retrieveData() {
        networkManager.getData() { [weak self] wishLists, errorMessage in
            if let error = errorMessage {
                print(error)
            }
            if let wishLists = wishLists {
                self?.wishListStore = wishLists
                self?.wishListSelectionViewModelDelegate?.updateWishListList()
            }
        }
    }

    
    func saveNewWishList(name: String, description: String) {
        let newWishList = WishList(id: nil, name: name, items: [], description: description)
        if WishListStoreHelper.checkForDuplication(itemToCheckFor: newWishList, listToCheckThrough: wishListStore, propertiesToCheckAgainst: [\WishList.name]) {
            return
        }
        networkManager.postData(dataToPost: newWishList, endpoint: "places/wishlists/"){ [weak self] wishList in
            self?.wishListStore.append(wishList)
            self?.wishListSelectionViewModelDelegate?.updateWishListList()
        }
    }
}
