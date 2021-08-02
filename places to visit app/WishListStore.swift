//
//  MapAnnotationsStore.swift
//  places to visit app
//
//  Created by Harriette Berndes on 23/07/2021.
//

import Foundation

class WishListStore: Codable {
    var wishLists: [WishList]
    
    init(wishLists: [WishList]) {
        self.wishLists = wishLists
    }
}
