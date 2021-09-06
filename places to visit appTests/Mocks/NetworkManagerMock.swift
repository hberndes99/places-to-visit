//
//  NetworkManagerMock.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 03/09/2021.
//

import Foundation
@testable import places_to_visit_app

class MockNetworkManager: NetworkManagerProtocol {
    var deleteItemCalled: Bool = false
    
    func getData(completion: @escaping (_ wishLists: [WishList]?, _ errorMessage: String?) -> Void) {
        let coffeePlaceOne = MapAnnotationPoint(id: 1, title: "coffee place one", subtitle: "", longitude: "50", latitude: "50", number: "1", streetAddress: "the street", wishList: 1)
        let coffeePlaceTwo = MapAnnotationPoint(id: 2, title: "coffee place two", subtitle: "2, the street", longitude: "30", latitude: "30", number: "2", streetAddress: "the street", wishList: 1)
        let coffeeWishList = WishList(id: 1, name: "coffee wish list", items: [coffeePlaceOne, coffeePlaceTwo], description: "chill coffee")
        let restaurantWishList = WishList(id: 2, name: "restaurant wish list", items: [], description: "restaurants")
        completion([coffeeWishList, restaurantWishList], nil)
    }
    
    func postData<T>(dataToPost: T, endpoint: String, completion: @escaping (T?, String?) -> ()) where T : Decodable, T : Encodable {
        print("in mock")
        completion(dataToPost, nil)
    }
    
    func deleteItem(endpoint: String, id: Int) {
        deleteItemCalled = true
    }
    
    
}
