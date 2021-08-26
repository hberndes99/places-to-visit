//
//  WishList.swift
//  places to visit app
//
//  Created by Harriette Berndes on 02/08/2021.
//

import Foundation

class WishList: Codable {
    var id: Int
    var name: String
    var description: String
    var items: [MapAnnotationPoint]
    
    init(id: Int, name: String, items: [MapAnnotationPoint], description: String) {
        self.id = id
        self.name = name
        self.items = items
        self.description = description
    }
}
