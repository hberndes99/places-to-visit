//
//  WishListSelectionViewModel.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 02/08/2021.
//

import XCTest
@testable import places_to_visit_app

class WishListSelectionViewModelTests: XCTestCase {
    
    var wishListSelectionViewModel: WishListSelectionViewModel!
    var wishListStore: WishListStore!
    
    override func setUpWithError() throws {
        wishListStore = WishListStore(wishLists: [])
        
        wishListSelectionViewModel = WishListSelectionViewModel(wishListStore: wishListStore)
    }

    override func tearDownWithError() throws {
        wishListStore = nil
        wishListSelectionViewModel = nil
    }

    func testSaveNewWishList() {
        wishListSelectionViewModel.saveNewWishList(name: "chill coffee shops", description: "calm coffee shops to work in")
        
        XCTAssertEqual(wishListSelectionViewModel.wishListStore.wishLists.count, 1)
        XCTAssertEqual(wishListSelectionViewModel.wishListStore.wishLists[0].name, "chill coffee shops")
    }
    
    func testSaveNewWishList_WishListWithSameNameAlreadyExists() {
        let currentWishList = WishList(name: "chill coffee shops", items: [], description: "")
        wishListSelectionViewModel.wishListStore.wishLists = [currentWishList]
        wishListSelectionViewModel.saveNewWishList(name: "chill coffee shops", description: "calm coffee shops to work in")
        
        XCTAssertEqual(wishListSelectionViewModel.wishListStore.wishLists.count, 1)
    }
   


}
