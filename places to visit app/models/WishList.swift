//
//  WishList.swift
//  places to visit app
//
//  Created by Harriette Berndes on 02/08/2021.
//

import Foundation

class WishList: Codable {
    var name: String
    var items: [MapAnnotationPoint]
    var description: String?
    
    init(name: String, items: [MapAnnotationPoint], description: String) {
        self.name = name
        self.items = items
        self.description = description
    }
}
