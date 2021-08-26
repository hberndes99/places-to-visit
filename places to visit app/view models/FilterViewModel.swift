//
//  FilterViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 11/08/2021.
//

import Foundation

class FilterViewModel {
    var wishListStore: [WishList] = [WishList]()
    var userDefaults: UserDefaultsProtocol
    var userDefaultsHelper: UserDefaultsHelperProtocol.Type
    weak var filterViewControllerDelegate: FilterViewControllerDelegate?
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
        //if listOfFilterStrings.count == 0 {
        //    return
        //}
        filterViewControllerDelegate?.applyFilters(filterList: listOfFilterStrings, distance: distanceToFilterBy)
    }
}
