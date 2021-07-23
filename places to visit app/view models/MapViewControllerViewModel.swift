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
    
    func savePlaceOfInterest(placeOfInterest: MKMapItem) {
        guard let placeName = placeOfInterest.placemark.name else { return }
        let newMapAnnotationPoint = MapAnnotationPoint(title: placeName, subtitle: "\(placeOfInterest.placemark.subThoroughfare ?? ""), \(placeOfInterest.placemark.thoroughfare ?? "")", coordinate: placeOfInterest.placemark.coordinate, placemark: placeOfInterest.placemark)
        mapAnnotationsStore.mapAnnotationPoints.append(newMapAnnotationPoint)
    }
}
