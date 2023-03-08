//
//  CollectionPresenter.swift
//  UnsplashTest
//
//  Created by bitocto_Barry on 08/03/23.
//

import Foundation

protocol CollectionPresenterToCollectionView : AnyObject {
    func itemsSet()
    func noMorePages()
    func foundError(_ error: ApiError)
}

protocol CollectionPresenterToRouter: AnyObject {
    static func createModule() -> CollectionViewController
}

protocol CollectionPresenterToCollectionInteractor: AnyObject {
    var presenter : CollectionInteractorToCollectionPresenter? {get set}
    func getItems(_ page : Int, _ query : String?)
}

class CollectionPresenter {
    
    var view : CollectionPresenterToCollectionView?
    var interactor : CollectionPresenterToCollectionInteractor?
    
    var items : [Item] = []{
        didSet{
            view?.itemsSet()
        }
    }
    private var hasNextPage = true
    private var page = 1
    
}

extension CollectionPresenter : CollectionViewToCollectionPresenter{
    
    func getItems(_ query: String?) {
        page = 1
        interactor?.getItems(page, query)
    }
    
    func getItemCount() -> Int {
        return items.count
    }
    
    func getMoreItems(_ query: String?) {
        
        if(!hasNextPage){
            view?.noMorePages()
            return
        }
        
        page = page + 1
        
        interactor?.getItems(page, query)
        
    }
    
    func findItem(_ index: Int) -> Item? {
        if(items.count > index){
            return items[index]
        } else {
            return nil
        }
    }
    
}

extension CollectionPresenter : CollectionInteractorToCollectionPresenter {
    
    
    func totalPage(_ total: Int) {
        hasNextPage = page < total
    }
    
    
    func itemsFetched(_ items: [Item]) {
        if(page == 1){
            self.items = items
        } else {
            self.items.append(contentsOf: items)
        }
    }
    
    func foundError(_ error: ApiError) {
        view?.foundError(error)
    }
    
    
}
