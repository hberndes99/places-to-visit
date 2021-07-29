//
//  PlacesListViewModel.swift
//  places to visit app
//
//  Created by Harriette Berndes on 29/07/2021.
//

import Foundation

class PlacesListViewModel {
    var mapAnnotationsStore: MapAnnotationsStore
    var userDefaults: UserDefaultsProtocol
    
    init(mapAnnotationsStore: MapAnnotationsStore, userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.mapAnnotationsStore = mapAnnotationsStore
        self.userDefaults = userDefaults
    }
    
    func retrieveData() {
        if let oldMapStore = userDefaults.data(forKey: Constants.savedPlaces) {
            let jsonDecoder = JSONDecoder()
            if let oldMapStoreDecoded = try? jsonDecoder.decode(MapAnnotationsStore.self, from: oldMapStore) {
                mapAnnotationsStore = oldMapStoreDecoded
            }
        }
    }
    
    func updateUserDefaults() {
        let jsonEncoder = JSONEncoder()
        if let encodedUpdatedPlaces = try? jsonEncoder.encode(mapAnnotationsStore) {
            userDefaults.setValue(encodedUpdatedPlaces, forKey: Constants.savedPlaces)
        }
    }
    
    func deletePlaceOfInterest(at position: Int) {
        mapAnnotationsStore.mapAnnotationPoints.remove(at: position)
        updateUserDefaults()
    }
}
