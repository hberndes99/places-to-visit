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

    weak var detailWishListViewModelDelegate: DetailWishListViewModelDelegate?
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
                self?.detailWishListViewModelDelegate?.updateDetailView()
            }
        }
    }
    
    func deletePlaceOfInterest(at position: Int, from wishListPosition: Int) {
        let mapPointToDelete = wishListStore[wishListPosition].items[position]
        if let id = mapPointToDelete.id {
            networkManager.deleteItem(endpoint: "places/wishlists/mappoints/", id: id)
            self.wishListStore[wishListPosition].items.remove(at: position)
        }
    }
    
    func deleteWishList(at position: Int, completion: @escaping () -> ()) {
        if wishListStore.count > position {
            if let id = wishListStore[position].id {
                networkManager.deleteItem(endpoint: "places/wishlists/", id: id)
                completion()
            }
            wishListStore.remove(at: position)
        }
    }
}
