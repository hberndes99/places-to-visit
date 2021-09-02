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
    func loadMapAnnotations()
}

class MapViewControllerViewModel {
    private(set) var filteringInPlace: Bool = false
    private var filterTerms: [String]?
    private var filterDistance: Int?
    private(set) var userCurrentLocation: CLLocation?
    var wishListStore: [WishList] = [WishList]()
    var userDefaults: UserDefaultsProtocol
    var userDefaultsHelper: UserDefaultsHelperProtocol.Type
    weak var mapViewControllerViewModelDelegate: MapViewControllerViewModelDelegate?
    
    //var wishListStoreToSave: WishListStore = WishListStore(wishLists: [])
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard,
         userDefaultsHelper: UserDefaultsHelperProtocol.Type = UserDefaultsHelper.self) {
        self.userDefaults = userDefaults
        self.userDefaultsHelper = userDefaultsHelper
    }
    
    func setUserLocation(currentLocation: CLLocation) {
        userCurrentLocation = currentLocation
    }
    
    func retrieveData() {
        NetworkManager.getData() { [weak self] wishLists in
            self?.wishListStore = wishLists
            self?.mapViewControllerViewModelDelegate?.loadMapAnnotations()
        }
        
        /*
        wishListStore = userDefaultsHelper.retrieveDataFromUserDefaults(userDefaults: userDefaults)
        if filteringInPlace {
            if let filterTerms = filterTerms {
                let filteredWishLists = wishListStore.wishLists.filter { wishList in
                    filterTerms.contains(wishList.name)
                }
                wishListStore.wishLists = filteredWishLists
            }
        }
        guard let filterDistance = filterDistance, let userCurrentLocation = userCurrentLocation else {
            return
        }
        filterMapPointsByDistance(numberOfKm: filterDistance)
 */
    }
    
    func savePlaceOfInterestToUserDefaults() {
        //wishListStoreToSave = wishListStore
        //userDefaultsHelper.updateUserDefaults(userDefaults: userDefaults, wishListStore: self.wishListStore)
    }
    
    func savePlaceOfInterest(placeOfInterest: MKMapItem, wishListId: Int) {
        var subtitleString: String = ""
        guard let placeName = placeOfInterest.name else { return }
        if placeOfInterest.placemark.subThoroughfare != nil,
           placeOfInterest.placemark.thoroughfare != nil {
            subtitleString = "\(placeOfInterest.placemark.subThoroughfare ?? ""), \(placeOfInterest.placemark.thoroughfare ?? "")"
        } else if placeOfInterest.placemark.thoroughfare != nil {
            subtitleString = "\(placeOfInterest.placemark.thoroughfare ?? "")"
        }
        let newMapAnnotationPoint = MapAnnotationPoint(id: nil,
                                                       title: placeName,
                                                       subtitle: subtitleString,
                                                       longitude: String(placeOfInterest.placemark.coordinate.longitude),
                                                       latitude: String(placeOfInterest.placemark.coordinate.latitude),
                                                       number: placeOfInterest.placemark.subThoroughfare ?? "",
                                                       streetAddress: placeOfInterest.placemark.thoroughfare ?? "",
                                                       wishList: wishListId)
        
        //     PREVENT DUPLICATION
        for place in wishListStore {
            for item in place.items {
                if item.title == newMapAnnotationPoint.title {
                    print("removed duplication")
                    return
                }
            }
        }
        
        NetworkManager.postMapPoint(mapPoint: newMapAnnotationPoint) { [weak self] mapAnnotationPoint in
            self?.wishListStore[wishListId].items.append(mapAnnotationPoint)
        }
        /*
        //retrieveData() only returning the filtered if filtering is in place
        //wishListStore = userDefaultsHelper.retrieveDataFromUserDefaults(userDefaults: userDefaults)
        // if adding to a list when filtering is in place there is an issue
        
        //let wishListToAddTo = wishListStore.wishLists[wishListPositionIndex]
        if WishListStoreHelper.checkForDuplication(itemToCheckFor: newMapAnnotationPoint, listToCheckThrough: wishListToAddTo.items, propertiesToCheckAgainst: [\MapAnnotationPoint.title]),
           WishListStoreHelper.checkForDuplication(itemToCheckFor: newMapAnnotationPoint, listToCheckThrough: wishListToAddTo.items,
            propertiesToCheckAgainst: [\MapAnnotationPoint.subtitle]) {
            return
        }
        wishListToAddTo.items.append(newMapAnnotationPoint)
       
        // this is then only saving the filtered lists to user defaults
        // other lists are removed from user defaults as a result and are no longer displayed
        savePlaceOfInterestToUserDefaults()
 */
    }
    
    private func filterMapPointsByDistance(numberOfKm: Int) {
        /*
        // filter the annotations by distance away from user location
        let filterDistance: Double = Double(numberOfKm * 1000)
        for wishList in wishListStore.wishLists {
            let filteredWishListItems = wishList.items.filter { mapPoint in
                let mapPointLocation = CLLocation(latitude: mapPoint.coordinate.latitude, longitude: mapPoint.coordinate.longitude)
                let distanceBetween = userCurrentLocation!.distance(from: mapPointLocation)
                if distanceBetween < filterDistance {
                    return true
                }
                return false
            }
            wishList.items = filteredWishListItems
        }
 */
    }
    
    func applyFiltersToMap(filterList: [String]?, distance: Int?) {
        /*
        if let filterList = filterList {
            let filteredWishLists = wishListStore.wishLists.filter { wishList in
                filterList.contains(wishList.name)
            }
            wishListStore.wishLists = filteredWishLists
            filteringInPlace = true
            filterTerms = filterList
        }
        if let filterDistance = distance, let _ = userCurrentLocation {
            self.filterDistance = filterDistance
            filteringInPlace = true
            filterMapPointsByDistance(numberOfKm: filterDistance)
        }
        mapViewControllerViewModelDelegate?.updateMapWithFilters()
    */
    }
    
    func clearFilters() {
        filteringInPlace = false
        filterTerms = nil
        filterDistance = nil
        retrieveData()
    }
}


protocol UserDefaultsProtocol {
    func setValue(_ value: Any?, forKey key: String)
    func data(forKey defaultName: String) -> Data?
}


extension UserDefaults: UserDefaultsProtocol {
    
}
