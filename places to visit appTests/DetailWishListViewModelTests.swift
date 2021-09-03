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
    var mockNetworkManager: MockNetworkManager!
    
    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        detailWishListViewModel = DetailWishListViewModel(networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
        detailWishListViewModel = nil
        mockNetworkManager = nil
    }
    
    func testRetrieveData() {
        var mockDetailWishListViewModelDelegate = MockDetailWishListViewModelDelegate()
        detailWishListViewModel.detailWishListViewModelDelegate = mockDetailWishListViewModelDelegate
        detailWishListViewModel.retrieveData()
        
        XCTAssertEqual(detailWishListViewModel.wishListStore.count, 2)
        XCTAssertEqual(detailWishListViewModel.wishListStore[0].name, "coffee wish list")
        XCTAssert(mockDetailWishListViewModelDelegate.updateDetailViewCalled)
    }
    


    func testDeletePlaceOfInterest() {
        detailWishListViewModel.retrieveData()
        detailWishListViewModel.deletePlaceOfInterest(at: 0, from: 0)
        
        XCTAssertEqual(detailWishListViewModel.wishListStore[0].items.count, 1)
        XCTAssertEqual(detailWishListViewModel.wishListStore[0].items[0].title, "coffee place two")
    }
    
    
    func testDeleteWishList_outOfRange() {
        detailWishListViewModel.retrieveData()
        detailWishListViewModel.deleteWishList(at: 0) {
            
        }
        
        XCTAssertEqual(detailWishListViewModel.wishListStore.count, 1)
        XCTAssertEqual(detailWishListViewModel.wishListStore[0].name, "restaurant wish list")
    }

}

class MockDetailWishListViewModelDelegate: DetailWishListViewModelDelegate {
    var updateDetailViewCalled: Bool = false
    func updateDetailView() {
        updateDetailViewCalled = true
    }
}
