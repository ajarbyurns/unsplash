//
//  ItemInteractor.swift
//  UnsplashTest
//
//  Created by bitocto_Barry on 08/03/23.
//

import Foundation

protocol ItemInteractorToItemPresenter : AnyObject {
    var interactor : ItemPresenterToItemInteractor? {get set}
    func imageDataFetched(_ data : Data, _ key : String)
    func foundError(_ error : ApiError)
    
}

class ItemInteractor {
    
    var presenter : ItemInteractorToItemPresenter?
    
}

extension ItemInteractor : ItemPresenterToItemInteractor {
    
    func getImage(_ urlString: String) {
        
        //print(urlString)
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.presenter?.foundError(.URL)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            guard error == nil, let data = data else {
                DispatchQueue.main.async{
                    self.presenter?.foundError(.Connection)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.presenter?.imageDataFetched(data, urlString)
            }
            
        }.resume()
    }
    
}
