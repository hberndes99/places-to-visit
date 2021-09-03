//
//  MockNetworkSession.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 03/09/2021.
//

import Foundation
@testable import places_to_visit_app

class MockNetworkSession: NetworkSession {
    
    let coffeePlaceOne = MapAnnotationPoint(id: 1, title: "coffee place one", subtitle: "", longitude: "50", latitude: "50", number: "1", streetAddress: "the street", wishList: 1)
    let coffeePlaceTwo = MapAnnotationPoint(id: 2, title: "coffee place two", subtitle: "2, the street", longitude: "30", latitude: "30", number: "2", streetAddress: "the street", wishList: 1)
    
    
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
        let coffeeWishList = WishList(id: 1, name: "coffee wish list", items: [coffeePlaceOne, coffeePlaceTwo], description: "chill coffee")
        let restaurantWishList = WishList(id: 2, name: "restaurant wish list", items: [], description: "restaurants")
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode([coffeeWishList, restaurantWishList])
        let response = HTTPURLResponse(url: URL(string: "url")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        completion(jsonData, response, nil)
        return MockNetworkTask()
    }
    
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
        let coffeeWishList = WishList(id: 1, name: "coffee wish list", items: [coffeePlaceOne, coffeePlaceTwo], description: "chill coffee")
        let restaurantWishList = WishList(id: 2, name: "restaurant wish list", items: [], description: "restaurants")
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode([coffeeWishList, restaurantWishList])
        let response = HTTPURLResponse(url: URL(string: "url")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        completion(jsonData, response, nil)
        return MockNetworkTask()
    }
    
    
}
