//
//  FilterViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 11/08/2021.
//

import Foundation

protocol FilterViewControllerDelegate: AnyObject {
    func applyFilters(filterList: [String]?, distance: Int?)
}

protocol FilterViewModelDelegate: AnyObject {
    func updateCollectionView()
}

class FilterViewModel {
    private(set) var wishListStore: [WishList] = [WishList]()
    private var userDefaults: UserDefaultsProtocol
    private var userDefaultsHelper: UserDefaultsHelperProtocol.Type
    
    weak var filterViewControllerDelegate: FilterViewControllerDelegate?
    weak var filterViewModelDelegate: FilterViewModelDelegate?
    
    private(set) var listOfFilterStrings: [String]?
    private(set) var distanceToFilterBy: Int?
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard,
         userDefaultsHelper: UserDefaultsHelperProtocol.Type = UserDefaultsHelper.self) {
        self.userDefaults = userDefaults
        self.userDefaultsHelper = userDefaultsHelper
    }
    
    // should be private
    func retrieveData() {
        NetworkManager.getData() { [weak self] wishLists in
            self?.wishListStore = wishLists
            self?.filterViewModelDelegate?.updateCollectionView()
        }
        //wishListStore = userDefaultsHelper.retrieveDataFromUserDefaults(userDefaults: userDefaults)
    }
    
    func addToFilterQueries(wishListName: String) {
        if listOfFilterStrings == nil {
            listOfFilterStrings = [String]()
        }
        listOfFilterStrings?.append(wishListName)
    }
    
    func removeFromFilterQueries(wishListName: String) {
        if let index = listOfFilterStrings?.firstIndex(of: wishListName) {
            listOfFilterStrings?.remove(at: index)
        }
        if listOfFilterStrings?.count == 0 {
            listOfFilterStrings = nil
        }
    }
    
    func filterByDistance(of distance: Int) {
        distanceToFilterBy = distance
    }
    
    func applyFilters() {
        filterViewControllerDelegate?.applyFilters(filterList: listOfFilterStrings, distance: distanceToFilterBy)
    }
}
