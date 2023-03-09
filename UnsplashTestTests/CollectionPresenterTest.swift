//
//  CollectionPresenterTest.swift
//  UnsplashTestTests
//
//  Created by bitocto_Barry on 09/03/23.
//

import XCTest
@testable import UnsplashTest

final class CollectionPresenterTest: XCTestCase {
    
    var sut : CollectionPresenter?
    var interactor : MockCollectionInteractor?
    var view : MockCollectionView?
    

    override func setUpWithError() throws {
        sut = CollectionPresenter()
        interactor = MockCollectionInteractor()
        view = MockCollectionView()
        sut?.view = view
        sut?.interactor = interactor
        interactor?.presenter = sut
        view?.presenter = sut
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        interactor = nil
        view = nil
        try super.tearDownWithError()
    }

    func testgetItemsCorrect() throws {
        interactor?.noReturn = false
        
        sut?.getItems("")
        
        XCTAssertTrue(sut?.items.count ?? 0 > 0)
        XCTAssertTrue(view?.success == true)
    }
    
    func testgetWrongItems() throws {
        interactor?.noReturn = true
        
        sut?.getItems("")
        
        XCTAssertFalse(view?.success == true)
    }
    
    func testGetMoreItems() throws {
        sut?.getMoreItems("")
        
        XCTAssertTrue(sut?.items.count ?? 0 > 0)
        XCTAssertTrue(view?.success == true)
    }
    
    func testGetItemCount() throws {
        sut?.items = [Item(width: 0, height: 0, urls: ItemURL(full: "", regular: "", small: ""))]
        
        XCTAssert(sut?.getItemCount() == 1)
    }
    
    func testFindItem() throws {
        
        sut?.items = [Item(width: 0, height: 0, urls: ItemURL(full: "", regular: "", small: ""))]
        
        let item = sut?.findItem(0)
        
        XCTAssertNotNil(item)
        
    }

}

class MockCollectionView : CollectionPresenterToCollectionView {
    
    var presenter: UnsplashTest.CollectionViewToCollectionPresenter?
    var success = false
    var noMore = false
    
    func itemsSet() {
        success = true
    }
    
    func noMorePages() {
        noMore = true
    }
    
    func foundError(_ error: UnsplashTest.ApiError) {
        success = false
    }
    
}

class MockCollectionInteractor : CollectionPresenterToCollectionInteractor {
    
    var presenter: UnsplashTest.CollectionInteractorToCollectionPresenter?
    var noReturn = false
    
    func getItems(_ page: Int, _ query: String?) {
        if(noReturn){
            presenter?.foundError(.Connection)
        } else {
            presenter?.itemsFetched([Item(width: 0, height: 0, urls: ItemURL(full: "", regular: "", small: ""))])
        }
    }
    
    
}
