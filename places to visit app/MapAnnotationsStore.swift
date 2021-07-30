//
//  MapAnnotationsStore.swift
//  places to visit app
//
//  Created by Harriette Berndes on 23/07/2021.
//

import Foundation

class MapAnnotationsStore: Codable {
    var mapAnnotationPoints: [MapAnnotationPoint] = []
}
// could give each MapAnnotationPoint a wish list property as a String which
// I can then use for filtering


class WishListStore: Codable {
    var wishLists: [WishList] = []
    
    init(wishLists: [WishList]) {
        self.wishLists = wishLists
    }
}

class WishList: Codable {
    var name: String
    var items: [MapAnnotationPoint]
    
    init(name: String, items: [MapAnnotationPoint]) {
        self.name = name
        self.items = items
    }
}
