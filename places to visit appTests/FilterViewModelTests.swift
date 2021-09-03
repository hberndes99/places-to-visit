//
//  FilterViewModelTests.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 16/08/2021.
//

import XCTest
@testable import places_to_visit_app


class FilterViewModelTests: XCTestCase {
    var filterViewModel: FilterViewModel!

    
    override func setUpWithError() throws {

        filterViewModel = FilterViewModel()
    }

    override func tearDownWithError() throws {
        filterViewModel = nil
    }

    func testRetrieveData() {
        filterViewModel.retrieveData()
        
        //XCTAssertEqual(filterViewModel.wishListStore.wishLists.count, 2)
        //XCTAssertEqual(filterViewModel.wishListStore.wishLists[0].name, "test coffee list")
    }
    
    func testAddToFilterQueries() {
        filterViewModel.addToFilterQueries(wishListName: "coffee shops")
        
        XCTAssertEqual(filterViewModel.listOfFilterStrings?.count, 1)
        XCTAssertEqual(filterViewModel.listOfFilterStrings?[0], "coffee shops")
    }
    
    func testRemoveFromFilterQueries() {
        filterViewModel.addToFilterQueries(wishListName: "coffee shops")
        filterViewModel.removeFromFilterQueries(wishListName: "coffee shops")
        XCTAssertEqual(filterViewModel.listOfFilterStrings, nil)
    }
    
    func testRemoveFromFilterQueries_twoItemsInFilterList() {
        filterViewModel.addToFilterQueries(wishListName: "coffee shops")
        filterViewModel.addToFilterQueries(wishListName: "restaurants")
        filterViewModel.removeFromFilterQueries(wishListName: "coffee shops")
        XCTAssertEqual(filterViewModel.listOfFilterStrings?.count, 1)
    }
    
    func testFilterByDistance() {
        filterViewModel.filterByDistance(of: 1)
        XCTAssertEqual(filterViewModel.distanceToFilterBy, 1)
    }
    
    func testApplyFilters() {
        let mockFilterViewControllerDelegate = MockFilterViewControllerDelegate()
        filterViewModel.filterViewControllerDelegate = mockFilterViewControllerDelegate
        
        filterViewModel.addToFilterQueries(wishListName: "coffee shops")
        filterViewModel.applyFilters()
        
        XCTAssert(mockFilterViewControllerDelegate.applyFiltersWasCalled)
    }
}

class MockFilterViewControllerDelegate: FilterViewControllerDelegate {
    var applyFiltersWasCalled: Bool = false
    func applyFilters(filterList: [String]?, distance: Int?) {
        applyFiltersWasCalled = true
    }

}
