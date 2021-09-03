//
//  PlacesListViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 29/07/2021.
//

import Foundation

protocol PlacesListViewModelDelegate: AnyObject {
    func updateWishListList()
}

class PlacesListViewModel {
    var wishListStore: [WishList] = [WishList]()
 
    weak var placesListViewModelDelegate: PlacesListViewModelDelegate?
    var networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func retrieveData() {
        networkManager.getData() { [weak self] wishLists in
            self?.wishListStore = wishLists
            self?.placesListViewModelDelegate?.updateWishListList()
        }
    }
}
