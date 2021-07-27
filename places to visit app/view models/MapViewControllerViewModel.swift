//
//  MapViewControllerViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 23/07/2021.
//

import Foundation
import MapKit

class MapViewControllerViewModel {
    var mapAnnotationsStore: MapAnnotationsStore
    var userDefaults: UserDefaultsProtocol
    
    init(mapAnnotationsStore: MapAnnotationsStore, userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.mapAnnotationsStore = mapAnnotationsStore
        self.userDefaults = userDefaults
    }
    
    func registerDefaults() {
        // registering default values for user defaults
        userDefaults.register(defaults: ["savedPlaces": Data()])
    }
    
    func retrieveData() {
        if let oldMapStore = userDefaults.data(forKey: "savedPlaces") {
            if let oldMapStoreDecoded = try? jsonDecoder.decode(MapAnnotationsStore.self, from: oldMapStore) {
                mapAnnotationsStore = oldMapStoreDecoded
            }
        }
    }
    
    func savePlaceOfInterestToUserDefaults() {
        
        if let encodedPlaces = try? jsonEncoder.encode(mapAnnotationsStore) {
            userDefaults.setValue(encodedPlaces, forKey: "savedPlaces")
        }
        /*
        if let oldMapStore = userDefaults.data(forKey: "savedPlaces") {
            if let oldMapStore = try? jsonDecoder.decode(MapAnnotationsStore.self, from: oldMapStore) {
                mapAnnotationsStore = oldMapStore
                mapAnnotationsStore.mapAnnotationPoints.append(placeOfInterest)
                if let encodedPlaces = try? jsonEncoder.encode(mapAnnotationsStore) {
                    userDefaults.setValue(encodedPlaces, forKey: "savedPlaces")
                }
            }
        }
        // alone this only saves those places added in the previous app session
        else {
            if let encodedPlaces = try? jsonEncoder.encode(mapAnnotationsStore) {
                userDefaults.setValue(encodedPlaces, forKey: "savedPlaces")
            }
        }
 */
    }
    
    func savePlaceOfInterest(placeOfInterest: MKMapItem) {
        // insert check that it doesn't already include that object
        var subtitleString: String = ""
        guard let placeName = placeOfInterest.name else { return }
        
        if placeOfInterest.placemark.subThoroughfare != nil, placeOfInterest.placemark.thoroughfare != nil {
            subtitleString = "\(placeOfInterest.placemark.subThoroughfare ?? ""), \(placeOfInterest.placemark.thoroughfare ?? "")"
        } else if placeOfInterest.placemark.thoroughfare != nil {
            subtitleString = "\(placeOfInterest.placemark.thoroughfare ?? "")"
        }
        
        let newMapAnnotationPoint = MapAnnotationPoint(title: placeName, subtitle: subtitleString, coordinate: placeOfInterest.placemark.coordinate, number: placeOfInterest.placemark.subThoroughfare ?? "", streetAddress: placeOfInterest.placemark.thoroughfare ?? "")
        
        for savedPoint in mapAnnotationsStore.mapAnnotationPoints {
            if savedPoint.title == newMapAnnotationPoint.title,
               savedPoint.subtitle == newMapAnnotationPoint.subtitle {
                print("place already saved")
                return
            }
        }
        
        mapAnnotationsStore.mapAnnotationPoints.append(newMapAnnotationPoint)
       
        
        // save place to user defaults
        savePlaceOfInterestToUserDefaults()
    }
}

protocol UserDefaultsProtocol {
    func register(defaults registrationDictionary: [String : Any])
    func setValue(_ value: Any?, forKey key: String)
    func data(forKey defaultName: String) -> Data?
}

extension UserDefaults: UserDefaultsProtocol {
    
}
