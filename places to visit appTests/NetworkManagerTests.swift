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
    var response: HTTPURLResponse!
    
    override func setUpWithError() throws {
        response = HTTPURLResponse(url: URL(string: "url")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockNetworkSession = MockNetworkSession(httpResponse: response)
        networkManager = NetworkManager(networkSessionObject: mockNetworkSession)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetData() {
        let expectation = XCTestExpectation(description: "")
        
        networkManager.getData { wishLists, errorMessage in
            XCTAssertEqual(wishLists?.count, 2)
            XCTAssertEqual(wishLists?[0].name, "coffee wish list mock network session")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testData_returnError() {
        mockNetworkSession.networkError = NetworkErrors.networkError
        networkManager = NetworkManager(networkSessionObject: mockNetworkSession)
        let expectation = XCTestExpectation(description: "")
        
        networkManager.getData { wishLists, errorMessage in
            XCTAssertEqual(wishLists, nil)
            XCTAssertEqual(wishLists?[0].name, nil)
            XCTAssertEqual(errorMessage, "error occured")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    // test for bad response
    func testGetData_badResponseCode() {
        response = HTTPURLResponse(url: URL(string: "url")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        mockNetworkSession = MockNetworkSession(httpResponse: response)
        networkManager = NetworkManager(networkSessionObject: mockNetworkSession)
        let expectation = XCTestExpectation(description: "")
        
        networkManager.getData { wishLists, errorMessage in
            XCTAssertEqual(wishLists, nil)
            XCTAssertEqual(wishLists?[0].name, nil)
            XCTAssertEqual(errorMessage, "bad response")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    // test for other requests
    
    func testPostData() {
        let newWishList = WishList(id: 3, name: "bookshops", items: [], description: "quiet interesting bookshops")
        let expectation = XCTestExpectation(description: "")
        networkManager.postData(dataToPost: newWishList, endpoint: "places/wishlists/") { wishList, errorMessage in
            XCTAssertEqual(wishList?.name, "bookshops")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testPostData_errorOccured() {
        let newWishList = WishList(id: 3, name: "bookshops", items: [], description: "quiet interesting bookshops")
        mockNetworkSession.networkError = NetworkErrors.networkError
        networkManager = NetworkManager(networkSessionObject: mockNetworkSession)
        
        let expectation = XCTestExpectation(description: "")
        networkManager.postData(dataToPost: newWishList, endpoint: "places/wishlists/") { wishList, errorMessage in
            XCTAssertEqual(errorMessage, "error occured")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testPostData_badResponse() {
        let newWishList = WishList(id: 3, name: "bookshops", items: [], description: "quiet interesting bookshops")
        mockNetworkSession.httpResponse = HTTPURLResponse(url: URL(string: "url")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        networkManager = NetworkManager(networkSessionObject: mockNetworkSession)
        let expectation = XCTestExpectation(description: "")
        networkManager.postData(dataToPost: newWishList, endpoint: "places/wishlists/") { wishList, errorMessage in
            XCTAssertEqual(errorMessage, "bad response")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}


