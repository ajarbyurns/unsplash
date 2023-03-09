//
//  ItemPresenterTest.swift
//  UnsplashTestTests
//
//  Created by bitocto_Barry on 09/03/23.
//

import XCTest
@testable import UnsplashTest

final class ItemPresenterTest: XCTestCase {
    
    var sut : ItemPresenter?
    var interactor : MockItemInteractor?
    var view : MockItemCell?
    
    let correctItem : Item = Item(width: 50, height: 50, urls: ItemURL(
        full: "https://images.unsplash.com/photo-1568317366565-ffef51fb0993?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw3NjE1OHwwfDF8c2VhcmNofDEwfHxCbHVlfGVufDB8fHx8MTY3ODI2MzEyNQ&ixlib=rb-4.0.3&q=80",
        regular: "https://images.unsplash.com/photo-1568317366565-ffef51fb0993?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw3NjE1OHwwfDF8c2VhcmNofDEwfHxCbHVlfGVufDB8fHx8MTY3ODI2MzEyNQ&ixlib=rb-4.0.3&q=80&w=1080",
        small: "https://images.unsplash.com/photo-1568317366565-ffef51fb0993?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw3NjE1OHwwfDF8c2VhcmNofDEwfHxCbHVlfGVufDB8fHx8MTY3ODI2MzEyNQ&ixlib=rb-4.0.3&q=80&w=400"))
    
    let wrongItem : Item = Item(width: 0, height: 0, urls: ItemURL(
        full: "",
        regular: "",
        small: ""))

    override func setUpWithError() throws {
        interactor = MockItemInteractor()
        sut = ItemPresenter(correctItem, interactor!)
        interactor?.presenter = sut
        view = MockItemCell()
        sut?.view = view
        view?.presenter = sut
        imageDataCache.removeAllObjects()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        interactor = nil
        view = nil
        try super.tearDownWithError()
    }

    func testLoadCorrectImage() throws {
        sut?.loadImage()
        
        XCTAssertNotNil(imageDataCache.object(forKey: "Test" as AnyObject) as? Data)
        XCTAssertNotNil(sut?.imgData)
        XCTAssertTrue(((view?.success) == true))
    }
    
    func testLoadWrongImage() throws {
        interactor?.noReturn = true
        sut?.loadImage()
        
        XCTAssertNil(imageDataCache.object(forKey: "Test" as AnyObject) as? Data)
        XCTAssertNil(sut?.imgData)
        XCTAssertFalse((view?.success) == true)
    }

}

class MockItemInteractor : ItemPresenterToItemInteractor {
    
    var presenter: UnsplashTest.ItemInteractorToItemPresenter?
    var noReturn = false
    
    func getImage(_ url: String) {
        if(!noReturn){
            presenter?.imageDataFetched(Data(), "Test")
        } else {
            presenter?.foundError(.Connection)
        }
    }

}

class MockItemCell : ItemPresenterToItemCell {
    
    var presenter: UnsplashTest.ItemCellToItemPresenter?
    var success = false
    
    func imageLoaded(_ imageData: Data) {
        success = true
    }
    
    func foundError(_ error: UnsplashTest.ApiError) {
        success = false
    }
    
    
    
    
}
