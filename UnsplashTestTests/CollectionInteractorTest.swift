//
//  CollectionInteractorTest.swift
//  UnsplashTestTests
//
//  Created by bitocto_Barry on 09/03/23.
//

import XCTest
@testable import UnsplashTest

final class CollectionInteractorTest: XCTestCase {
    
    var sut : CollectionInteractor?
    var mockPresenter : MockPresenter?

    override func setUpWithError() throws {
        sut = CollectionInteractor()
        mockPresenter = MockPresenter(self)
        sut?.presenter = mockPresenter
        mockPresenter?.interactor = sut
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockPresenter = nil
        try super.tearDownWithError()
    }

    func testGetDataWithRightQuery() throws {
        mockPresenter?.itemsExpectation = expectation(description: "Items Set")
        sut?.getItems(1, "Blue")
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertTrue(mockPresenter?.items.count ?? 0 > 0)
        XCTAssertTrue(mockPresenter?.total ?? 0 > 0)
    }
    
    func testGetDataWithWrongQuery() throws {
        mockPresenter?.itemsExpectation = expectation(description: "Items Set")
        sut?.getItems(1, "sdvsdvds")
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertFalse(mockPresenter?.items.count ?? 0 > 0)
        XCTAssertTrue(mockPresenter?.total == 0)
    }

}

class MockPresenter : CollectionInteractorToCollectionPresenter {
    
    var interactor: UnsplashTest.CollectionPresenterToCollectionInteractor?
    var itemsExpectation: XCTestExpectation?
    var errorExpectation : XCTestExpectation?
    var items : [UnsplashTest.Item] = []
    var total : Int = 0
    
    private let testCase: XCTestCase
    
    init(_ testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    func itemsFetched(_ items: [UnsplashTest.Item]) {
        self.items = items
        itemsExpectation?.fulfill()
    }
    
    func foundError(_ error: UnsplashTest.ApiError) {
        errorExpectation?.fulfill()
    }
    
    func totalPage(_ total: Int) {
        self.total = total
    }
    
    
}
