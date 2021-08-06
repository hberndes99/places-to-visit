//
//  MapViewControllerViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 23/07/2021.
//

import Foundation
import MapKit

class MapViewControllerViewModel {
    var wishListStore: WishListStore
    var userDefaults: UserDefaultsProtocol
    var userDefaultsHelper: UserDefaultsHelperProtocol.Type
    
    init(wishListStore: WishListStore,
         userDefaults: UserDefaultsProtocol = UserDefaults.standard,
         userDefaultsHelper: UserDefaultsHelperProtocol.Type = UserDefaultsHelper.self) {
        self.wishListStore = wishListStore
        self.userDefaults = userDefaults
        self.userDefaultsHelper = userDefaultsHelper
    }
    
    // why does it force me to add the user default parameter
    func retrieveData() {
        wishListStore = userDefaultsHelper.retrieveDataFromUserDefaults(userDefaults: userDefaults)
    }
    
    // why does it force me to add the user default parameter
    func savePlaceOfInterestToUserDefaults() {
        userDefaultsHelper.updateUserDefaults(userDefaults: userDefaults, wishListStore: self.wishListStore)
    }
    
    func savePlaceOfInterest(placeOfInterest: MKMapItem, wishListPositionIndex: Int) {
        var subtitleString: String = ""
        guard let placeName = placeOfInterest.name else { return }
        
        if placeOfInterest.placemark.subThoroughfare != nil, placeOfInterest.placemark.thoroughfare != nil {
            subtitleString = "\(placeOfInterest.placemark.subThoroughfare ?? ""), \(placeOfInterest.placemark.thoroughfare ?? "")"
        } else if placeOfInterest.placemark.thoroughfare != nil {
            subtitleString = "\(placeOfInterest.placemark.thoroughfare ?? "")"
        }
        
        let newMapAnnotationPoint = MapAnnotationPoint(title: placeName, subtitle: subtitleString, coordinate: placeOfInterest.placemark.coordinate, number: placeOfInterest.placemark.subThoroughfare ?? "", streetAddress: placeOfInterest.placemark.thoroughfare ?? "")
        
        for wishList in wishListStore.wishLists {
            for savedPoint in wishList.items {
                if savedPoint.title == newMapAnnotationPoint.title,
                   savedPoint.subtitle == newMapAnnotationPoint.subtitle {
                    print("place already saved")
                    return
                }
            }
        }
 
        retrieveData()
        let wishListToAddTo = wishListStore.wishLists[wishListPositionIndex]
        wishListToAddTo.items.append(newMapAnnotationPoint)
       
        savePlaceOfInterestToUserDefaults()
    }
}

protocol UserDefaultsProtocol {
    func setValue(_ value: Any?, forKey key: String)
    func data(forKey defaultName: String) -> Data?
}

extension UserDefaults: UserDefaultsProtocol {
    
}
