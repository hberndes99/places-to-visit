//
//  MapAnnotation.swift
//  map-lists
//
//  Created by Harriette Berndes on 09/07/2021.
//

import Foundation
import MapKit

class MapAnnotationPoint: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let placemark: MKPlacemark?
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, placemark: MKPlacemark) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.placemark = placemark
        
        super.init()
    }
}
