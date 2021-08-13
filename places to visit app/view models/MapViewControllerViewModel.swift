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
    var wishListStore: WishListStore
    var userDefaults: UserDefaultsProtocol
    var userDefaultsHelper: UserDefaultsHelperProtocol.Type
    weak var mapViewControllerViewModelDelegate: MapViewControllerViewModelDelegate?
    
    init(wishListStore: WishListStore,
         userDefaults: UserDefaultsProtocol = UserDefaults.standard,
         userDefaultsHelper: UserDefaultsHelperProtocol.Type = UserDefaultsHelper.self) {
        self.wishListStore = wishListStore
        self.userDefaults = userDefaults
        self.userDefaultsHelper = userDefaultsHelper
    }
    
    func retrieveData() {
        wishListStore = userDefaultsHelper.retrieveDataFromUserDefaults(userDefaults: userDefaults)
    }
    
    func savePlaceOfInterestToUserDefaults() {
        userDefaultsHelper.updateUserDefaults(userDefaults: userDefaults, wishListStore: self.wishListStore)
    }
    
    func savePlaceOfInterest(placeOfInterest: MKMapItem, wishListPositionIndex: Int) {
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
        retrieveData()
        let wishListToAddTo = wishListStore.wishLists[wishListPositionIndex]
        if WishListStoreHelper.checkForDuplication(itemToCheckFor: newMapAnnotationPoint, listToCheckThrough: wishListToAddTo.items, propertiesToCheckAgainst: [\MapAnnotationPoint.title]),
           WishListStoreHelper.checkForDuplication(itemToCheckFor: newMapAnnotationPoint, listToCheckThrough: wishListToAddTo.items,
            propertiesToCheckAgainst: [\MapAnnotationPoint.subtitle]) {
            print("item is already in that list")
            return
        }
        wishListToAddTo.items.append(newMapAnnotationPoint)
        print("saved new place")
       
        savePlaceOfInterestToUserDefaults()
    }
    
    
    func applyFiltersToMap(filterList: [String]) {
        let filteredWishLists = wishListStore.wishLists.filter { wishList in
            filterList.contains(wishList.name)
        }
        wishListStore.wishLists = filteredWishLists
        mapViewControllerViewModelDelegate?.updateMapWithFilters()
    }
}

protocol UserDefaultsProtocol {
    func setValue(_ value: Any?, forKey key: String)
    func data(forKey defaultName: String) -> Data?
}

extension UserDefaults: UserDefaultsProtocol {
    
}
