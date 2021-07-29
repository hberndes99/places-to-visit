//
//  MapAnnotation.swift
//  map-lists
//
//  Created by Harriette Berndes on 09/07/2021.
//

import Foundation
import MapKit

class MapAnnotationPoint: NSObject, MKAnnotation, Codable {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    //let placemark: MKPlacemark?
    let number: String?
    let streetAddress: String?
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, number: String, streetAddress: String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        //self.placemark = placemark
        self.number = number
        self.streetAddress = streetAddress
        
        super.init()
    }
}

extension CLLocationCoordinate2D: Codable {
    public enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
    }
}

