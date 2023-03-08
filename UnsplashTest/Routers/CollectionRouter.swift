//
//  Router.swift
//  UnsplashTest
//
//  Created by bitocto_Barry on 08/03/23.
//

import Foundation

class CollectionRouter : CollectionPresenterToRouter {
        
    static func createModule() -> CollectionViewController {
            
        let view = CollectionViewController()
        
        let presenter: CollectionViewToCollectionPresenter & CollectionInteractorToCollectionPresenter = CollectionPresenter()
        let interactor: CollectionPresenterToCollectionInteractor = CollectionInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
        
    }
    
}
