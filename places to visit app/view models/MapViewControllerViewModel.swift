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
    
    private func filterMapPointsByDistance(numberOfKm: Int, userLocation: CLLocation) {
        // filter the annotations by distance away from user location
        let filterDistance: Double = Double(numberOfKm * 1000)
        // get users location point
        
        //filter through the wish lists, find distance from user location, return point if it is less than filterDistance
        var mapPointsWithinDistance = [MapAnnotationPoint]()
        for wishList in wishListStore.wishLists {
            let filteredWishListItems = wishList.items.filter { mapPoint in
                let mapPointLocation = CLLocation(latitude: mapPoint.coordinate.latitude, longitude: mapPoint.coordinate.longitude)
                let distanceBetween = userLocation.distance(from: mapPointLocation)
                if distanceBetween < filterDistance {
                    return true
                }
                return false
            }
            print(filteredWishListItems)
            wishList.items = filteredWishListItems
        
            
            /*
            for mapPoint in wishList.items {
                let mapPointLocation = CLLocation(latitude: mapPoint.coordinate.latitude, longitude: mapPoint.coordinate.longitude)
                let distanceBetween = userLocation.distance(from: mapPointLocation)
                if distanceBetween < filterDistance {
                    // neeed to return it so these points only are displayed on map
                    //print(mapPoint.title)
                    mapPointsWithinDistance.append(mapPoint)
                }
            }
            */
 
        }
    }
    
    func applyFiltersToMap(filterList: [String], distance: Int?, userLocation: CLLocation?) {
        let filteredWishLists = wishListStore.wishLists.filter { wishList in
            filterList.contains(wishList.name)
        }
        wishListStore.wishLists = filteredWishLists
        filteringInPlace = true
        filterTerms = filterList
        if let filterDistance = distance, let userLocation = userLocation {
            filterMapPointsByDistance(numberOfKm: filterDistance, userLocation: userLocation)
        }
        mapViewControllerViewModelDelegate?.updateMapWithFilters()
    }
    
  
    
    func clearFilters() {
        filteringInPlace = false
        filterTerms = nil
        retrieveData()
    }
}


protocol UserDefaultsProtocol {
    func setValue(_ value: Any?, forKey key: String)
    func data(forKey defaultName: String) -> Data?
}


extension UserDefaults: UserDefaultsProtocol {
    
}
