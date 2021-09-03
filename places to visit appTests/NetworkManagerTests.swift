//
//  NetworkManagerTests.swift
//  places to visit appTests
//
//  Created by Harriette Berndes on 03/09/2021.
//

import XCTest
@testable import places_to_visit_app

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    var mockNetworkSession: MockNetworkSession!
    
    override func setUpWithError() throws {
        mockNetworkSession = MockNetworkSession()
        networkManager = NetworkManager(networkSessionObject: mockNetworkSession)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetData() {
        let expectation = XCTestExpectation(description: "")
        
        networkManager.getData { wishList in
            XCTAssertEqual(wishList.count, 2)
            XCTAssertEqual(wishList[0].name, "coffee wish list")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    
}
