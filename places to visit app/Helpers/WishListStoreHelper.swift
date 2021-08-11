//
//  WishListStoreHelper.swift
//  places to visit app
//
//  Created by Harriette Berndes on 10/08/2021.
//

import Foundation

class WishListStoreHelper {
    
    static func checkForDuplication <T, S: Equatable>(itemToCheckFor: T, listToCheckThrough: [T], propertiesToCheckAgainst: [KeyPath<T, S>]) -> Bool {
        for item in listToCheckThrough {
            for property in propertiesToCheckAgainst {
                if item[keyPath: property] == itemToCheckFor[keyPath: property] {
                    print("items checked through, round a match")
                    return true
                }
            }
        }
        print("items checked through, no matches present")
        return false
    }
}
