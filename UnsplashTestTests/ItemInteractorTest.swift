//
//  UnsplashTestTests.swift
//  UnsplashTestTests
//
//  Created by bitocto_Barry on 08/03/23.
//

import XCTest
@testable import UnsplashTest

final class ItemInteractorTest: XCTestCase {

    var sut : ItemInteractor?
    var mockPresenter : MockItemPresenter?
    
    let correctURL = "https://images.unsplash.com/photo-1568317366565-ffef51fb0993?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw3NjE1OHwwfDF8c2VhcmNofDEwfHxCbHVlfGVufDB8fHx8MTY3ODI2MzEyNQ&ixlib=rb-4.0.3&q=80&w=400"
    let wrongURL = "gdfgdfgdddvdvd"

    override func setUpWithError() throws {
        sut = ItemInteractor()
        mockPresenter = MockItemPresenter(self)
        sut?.presenter = mockPresenter
        mockPresenter?.interactor = sut
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockPresenter = nil
        try super.tearDownWithError()
    }

    func testGetDataWithRightURL() throws {
        mockPresenter?.imageExpectation = expectation(description: "Image Set")
        sut?.getImage(correctURL)
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertNotNil(mockPresenter?.data)
        XCTAssert(mockPresenter?.key.isEmpty == false)
    }
    
    func testGetDataWithWrongURL() throws {
        mockPresenter?.errorExpectation = expectation(description: "Error Found")
        sut?.getImage(wrongURL)
        
        waitForExpectations(timeout: 10.0)
        
        XCTAssertNil(mockPresenter?.data)
        XCTAssert(mockPresenter?.key.isEmpty == true)
    }


}

class MockItemPresenter : ItemInteractorToItemPresenter {
    
    var interactor: UnsplashTest.ItemPresenterToItemInteractor?
    var imageExpectation: XCTestExpectation?
    var errorExpectation : XCTestExpectation?
    var data : Data? = nil
    var key = ""
    
    private let testCase: XCTestCase
    
    init(_ testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    func imageDataFetched(_ data: Data, _ key: String) {
        self.data = data
        self.key = key
        imageExpectation?.fulfill()
    }
    
    func foundError(_ error: UnsplashTest.ApiError) {
        errorExpectation?.fulfill()
    }
    
    
}
