//
//  DetailWishListViewModelTests.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 23/08/2021.
//

import XCTest
@testable import places_to_visit_app
import MapKit

class DetailWishListViewModelTests: XCTestCase {
    var detailWishListViewModel: DetailWishListViewModel!
    
    override func setUpWithError() throws {

        detailWishListViewModel = DetailWishListViewModel()
        
        
        
    }

    override func tearDownWithError() throws {
        detailWishListViewModel = nil

    }
    
    func testRetrieveData() {
        detailWishListViewModel.retrieveData()
        
        //XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists.count, 2)
        //XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists[0].name, "test coffee list")
    }
    


    func testDeletePlaceOfInterest() {
        detailWishListViewModel.deletePlaceOfInterest(at: 0, from: 0)
        
        //XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists[0].items.count, 1)
            //XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists[0].items[0].title, "coffee place two")
    }
    
    func testDeletePlaceOfInterest_outOfRange() {
        detailWishListViewModel.deletePlaceOfInterest(at: 3, from: 0)
        
        //XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists[0].items.count, 2)
        //XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists[0].items[0].title, "coffee place one")
    }
    
   
    
    func testDeleteWishList_outOfRange() {
        //detailWishListViewModel.deleteWishList(at: 2)
        
        //XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists.count, 2)
        //XCTAssertEqual(detailWishListViewModel.wishListStore.wishLists[0].name, "coffee")
    }

}
