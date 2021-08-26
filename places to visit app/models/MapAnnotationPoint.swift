//
//  MapAnnotation.swift
//  map-lists
//
//  Created by Harriette Berndes on 09/07/2021.
//

import Foundation
import MapKit

class MapAnnotationPoint: NSObject, MKAnnotation, Codable {
    var id: Int
    var title: String?
    var subtitle: String?
    var longitude: String
    var latitude: String
    var coordinate : CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0)
        }
    var number: String?
    var streetAddress: String?
    var wishList: Int
    
    
    init(id: Int, title: String, subtitle: String, longitude: String, latitude: String, number: String?, streetAddress: String?, wishList: Int) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.longitude = longitude
        self.latitude = latitude
        self.number = number
        self.streetAddress = streetAddress
        self.wishList = wishList
        
        super.init()
    }
    /*
    required init(from decoder: Decoder) {
        
        print("decoding init")
        self.id = 0
        //self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(10), longitude: CLLocationDegrees(10))
        self.wishList = 0
    }
 */
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

