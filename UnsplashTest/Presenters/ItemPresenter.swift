//
//  ItemPresenter.swift
//  UnsplashTest
//
//  Created by bitocto_Barry on 08/03/23.
//

import Foundation

protocol ItemPresenterToItemCell : AnyObject {
    func imageLoaded(_ imageData : Data)
    func foundError(_ error: ApiError)
}

protocol ItemPresenterToItemInteractor: AnyObject {
    var presenter:ItemInteractorToItemPresenter? {get set}
    func getImage(_ url : String)
}

var imageDataCache = NSCache<AnyObject, AnyObject>()

class ItemPresenter {
    
    var interactor : ItemPresenterToItemInteractor?
    weak var view : ItemPresenterToItemCell?
    
    var item : Item
    var imgData : Data?{
        didSet{
            if let data = imgData {
                view?.imageLoaded(data)
            }
        }
    }
    
    init(_ item : Item, _ interactor : ItemPresenterToItemInteractor){
        self.item = item
        self.imgData = imageDataCache.object(forKey: self.item.urls?.small as AnyObject) as? Data
        self.interactor = interactor
        self.interactor?.presenter = self
    }
    
}

extension ItemPresenter : ItemCellToItemPresenter {
    
    func loadImage(){
        
        if let data = imgData {
            view?.imageLoaded(data)
            return
        }
        
        if let url = self.item.urls?.small {
            interactor?.getImage(url)
        }
    }
    
}

extension ItemPresenter : ItemInteractorToItemPresenter {
    
    func imageDataFetched(_ data: Data, _ key : String) {
        imageDataCache.setObject(data as AnyObject, forKey: key as AnyObject)
        view?.imageLoaded(imageDataCache.object(forKey: key as AnyObject) as! Data)
    }
    
    func foundError(_ error: ApiError) {
        view?.foundError(error)
    }
    
    
}
