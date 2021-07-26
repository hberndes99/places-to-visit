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
    
    init(mapAnnotationsStore: MapAnnotationsStore) {
        self.mapAnnotationsStore = mapAnnotationsStore
    }
    
    func savePlaceOfInterestToUserDefaults(save placeOfInterest: MapAnnotationPoint) {
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
        if let encodedPlaces = try? jsonEncoder.encode(mapAnnotationsStore) {
            userDefaults.setValue(encodedPlaces, forKey: "savedPlaces")
        }
        
        /*
        if let alreadySaved = userDefaults.data(forKey: "savedPlaces") {
            print("not empty route")
            if let mapAnnotationsStore = try? jsonDecoder.decode(MapAnnotationsStore.self, from: alreadySaved) {
                print("appending")
                mapAnnotationsStore.mapAnnotationPoints.append(placeOfInterest)
                if let encodedPlaces = try? jsonEncoder.encode(mapAnnotationsStore) {
                    userDefaults.setValue(encodedPlaces, forKey: "savedPlaces")
                }
            }
        }
        else {
            print("right route")
            // list empty
            // let listToSave = [placeOfInterest]
            mapAnnotationsStore.mapAnnotationPoints = [placeOfInterest]
            let store = mapAnnotationsStore.mapAnnotationPoints
            if let encodedPlace = try? jsonEncoder.encode(store) {
                userDefaults.setValue(encodedPlace, forKey: "savedPlaces")
            }
        }
 */
        
    }
    
    func savePlaceOfInterest(placeOfInterest: MKMapItem) {
        // insert check that it doesn't already include that object
        guard let placeName = placeOfInterest.placemark.name else { return }
        let newMapAnnotationPoint = MapAnnotationPoint(title: placeName, subtitle: "\(placeOfInterest.placemark.subThoroughfare ?? ""), \(placeOfInterest.placemark.thoroughfare ?? "")", coordinate: placeOfInterest.placemark.coordinate, number: placeOfInterest.placemark.subThoroughfare ?? "", streetAddress: placeOfInterest.placemark.thoroughfare ?? "")
        mapAnnotationsStore.mapAnnotationPoints.append(newMapAnnotationPoint)
        
        // save place to user defaults
        savePlaceOfInterestToUserDefaults(save: newMapAnnotationPoint)
    }
}
