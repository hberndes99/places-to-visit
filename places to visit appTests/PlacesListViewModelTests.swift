//
//  PlacesListViewModel.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 30/07/2021.
//

import XCTest
@testable import places_to_visit_app
import MapKit

class PlacesListViewModelTests: XCTestCase {
    
    var placesListViewModel: PlacesListViewModel!

    var coffeePlaceOne: MapAnnotationPoint!
    var coffeeWishList: WishList!
    
    override func setUpWithError() throws {

        
        placesListViewModel = PlacesListViewModel()
        
        coffeePlaceOne = MapAnnotationPoint(id: 1, title: "coffee place one", subtitle: "1, the street", longitude: "50", latitude: "50", number: "1", streetAddress: "the street", wishList: 1)
        
        coffeeWishList = WishList(id: 1, name: "coffee wish list", items: [], description: "chill coffee")
    }

    override func tearDownWithError() throws {
        placesListViewModel = nil
        
    }

    func testRetrieveData() {
        placesListViewModel.retrieveData()
        
        //XCTAssertEqual(placesListViewModel.wishListStore.wishLists.count, 2)
        //XCTAssertEqual(placesListViewModel.wishListStore.wishLists[0].name, "test coffee list")
    }
    
   
    

    
}
