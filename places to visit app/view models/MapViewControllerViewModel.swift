//
//  MapViewControllerViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 23/07/2021.
//

import Foundation
import MapKit

protocol MapViewControllerViewModelDelegate: AnyObject {
    func updateMapWithFilters() 
}

class MapViewControllerViewModel {
    private(set) var filteringInPlace: Bool = false
    private var filterTerms: [String]?
    var wishListStore: WishListStore
    var userDefaults: UserDefaultsProtocol
    var userDefaultsHelper: UserDefaultsHelperProtocol.Type
    weak var mapViewControllerViewModelDelegate: MapViewControllerViewModelDelegate?
    
    var wishListStoreToSave: WishListStore = WishListStore(wishLists: [])
    
    init(wishListStore: WishListStore,
         userDefaults: UserDefaultsProtocol = UserDefaults.standard,
         userDefaultsHelper: UserDefaultsHelperProtocol.Type = UserDefaultsHelper.self) {
        self.wishListStore = wishListStore
        self.userDefaults = userDefaults
        self.userDefaultsHelper = userDefaultsHelper
    }
    
    func retrieveData() {
        wishListStore = userDefaultsHelper.retrieveDataFromUserDefaults(userDefaults: userDefaults)
        if filteringInPlace {
            if let filterTerms = filterTerms {
                let filteredWishLists = wishListStore.wishLists.filter { wishList in
                    filterTerms.contains(wishList.name)
                }
                wishListStore.wishLists = filteredWishLists
            }
        }
    }
    
    func savePlaceOfInterestToUserDefaults() {
        wishListStoreToSave = wishListStore
        userDefaultsHelper.updateUserDefaults(userDefaults: userDefaults, wishListStore: self.wishListStore)
    }
    
    func savePlaceOfInterest(placeOfInterest: MKMapItem, wishListPositionIndex: Int) {
        print("save place of interest being called")
        var subtitleString: String = ""
        guard let placeName = placeOfInterest.name else { return }
        if placeOfInterest.placemark.subThoroughfare != nil,
           placeOfInterest.placemark.thoroughfare != nil {
            subtitleString = "\(placeOfInterest.placemark.subThoroughfare ?? ""), \(placeOfInterest.placemark.thoroughfare ?? "")"
        } else if placeOfInterest.placemark.thoroughfare != nil {
            subtitleString = "\(placeOfInterest.placemark.thoroughfare ?? "")"
        }
        let newMapAnnotationPoint = MapAnnotationPoint(title: placeName,
                                                       subtitle: subtitleString,
                                                       coordinate: placeOfInterest.placemark.coordinate,
                                                       number: placeOfInterest.placemark.subThoroughfare ?? "",
                                                       streetAddress: placeOfInterest.placemark.thoroughfare ?? "")
        //retrieveData() only returning the filtered if filtering is in place
        wishListStore = userDefaultsHelper.retrieveDataFromUserDefaults(userDefaults: userDefaults)
        // if adding to a list when filtering is in place there is an issue
        
        let wishListToAddTo = wishListStore.wishLists[wishListPositionIndex]
        if WishListStoreHelper.checkForDuplication(itemToCheckFor: newMapAnnotationPoint, listToCheckThrough: wishListToAddTo.items, propertiesToCheckAgainst: [\MapAnnotationPoint.title]),
           WishListStoreHelper.checkForDuplication(itemToCheckFor: newMapAnnotationPoint, listToCheckThrough: wishListToAddTo.items,
            propertiesToCheckAgainst: [\MapAnnotationPoint.subtitle]) {
            return
        }
        wishListToAddTo.items.append(newMapAnnotationPoint)
       
        // this is then only saving the filtered lists to user defaults
        // other lists are removed from user defaults as a result and are no longer displayed
        savePlaceOfInterestToUserDefaults()
    }
    
    func applyFiltersToMap(filterList: [String]) {
        let filteredWishLists = wishListStore.wishLists.filter { wishList in
            filterList.contains(wishList.name)
        }
        wishListStore.wishLists = filteredWishLists
        filteringInPlace = true
        filterTerms = filterList
        mapViewControllerViewModelDelegate?.updateMapWithFilters()
    }
    
    func clearFilters() {
        filteringInPlace = false
        retrieveData()
    }
}


protocol UserDefaultsProtocol {
    func setValue(_ value: Any?, forKey key: String)
    func data(forKey defaultName: String) -> Data?
}


extension UserDefaults: UserDefaultsProtocol {
    
}
