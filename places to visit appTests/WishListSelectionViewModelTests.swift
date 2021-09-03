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
    var mockNetworkManager: MockNetworkManager!
    var mockWishListSelectionViewModelDelegate: MockWishListSelectionViewModelDelegate!
    
    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        wishListSelectionViewModel = WishListSelectionViewModel(networkManager: mockNetworkManager)
        mockWishListSelectionViewModelDelegate = MockWishListSelectionViewModelDelegate()
        wishListSelectionViewModel.wishListSelectionViewModelDelegate = mockWishListSelectionViewModelDelegate
    }

    override func tearDownWithError() throws {
        wishListSelectionViewModel = nil
        mockNetworkManager = nil
    }

    
    func testRetrieveData() {
        wishListSelectionViewModel.retrieveData()
        
        XCTAssertEqual(wishListSelectionViewModel.wishListStore.count, 2)
        XCTAssertEqual(wishListSelectionViewModel.wishListStore[0].items.count, 2)
        
    }
    
    
   
    
    func testSaveNewWishList() {

        wishListSelectionViewModel.saveNewWishList(name: "book shop list", description: "for a browse")
        
        XCTAssertEqual(wishListSelectionViewModel.wishListStore.count, 1)
        XCTAssertEqual(wishListSelectionViewModel.wishListStore[0].name, "book shop list")
        XCTAssert(mockWishListSelectionViewModelDelegate.updateWishListListCalled)
    }
    
    func testSaveNewWishList_WishListWithSameNameAlreadyExists() {
        wishListSelectionViewModel.retrieveData()
        wishListSelectionViewModel.saveNewWishList(name: "coffee wish list", description: "calm coffee shops to work in")
        
        XCTAssertEqual(wishListSelectionViewModel.wishListStore.count, 2)
        XCTAssertFalse(mockWishListSelectionViewModelDelegate.updateWishListListCalled)
    }

}

class MockWishListSelectionViewModelDelegate: WishListSelectionViewModelDelegate {
    var updateWishListListCalled: Bool = false
    func updateWishListList() {
        updateWishListListCalled = true
    }
}
