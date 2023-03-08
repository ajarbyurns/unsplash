//
//  CollectionInteractor.swift
//  UnsplashTest
//
//  Created by bitocto_Barry on 08/03/23.
//

import Foundation

protocol CollectionInteractorToCollectionPresenter : AnyObject {
    var interactor : CollectionPresenterToCollectionInteractor? {get set}
    func itemsFetched(_ items : [Item])
    func foundError(_ error : ApiError)
    func totalPage(_ total : Int)
    
}

class CollectionInteractor {
    
    var presenter : CollectionInteractorToCollectionPresenter?
    let ACCESS_KEY = "d8a272c480b258b875d82f4062d6c52e4ae7f4b4656add778d71e9b638b2f8be"
    
}

extension CollectionInteractor : CollectionPresenterToCollectionInteractor {
    
    func getItems(_ page : Int = 1, _ query : String? = nil) {
        
        var urlComp = URLComponents(string : "https://api.unsplash.com/search/photos")
        if let query = query {
            let queries = [URLQueryItem(name:"page", value: "\(page)"),
                           URLQueryItem(name:"query", value: query)]
            urlComp?.queryItems = queries
        }
        
        guard urlComp?.url != nil else {
            return
        }
        
        var request = URLRequest(url: urlComp!.url!)
        request.addValue("Client-ID \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
                
        URLSession.shared.dataTask(with: request) { data, response, error in
                        
            guard error == nil, let data = data else {
                DispatchQueue.main.async {
                    self.presenter?.foundError(.Connection)
                }
                return
            }
            
            do {
                /*let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(json)*/
                
                let decoder = JSONDecoder()
                
                let res : ItemResponse = try decoder.decode(ItemResponse.self, from: data)
                
                DispatchQueue.main.async {
                    if let items = res.results, let total = res.total_pages {
                        self.presenter?.itemsFetched(items)
                        self.presenter?.totalPage(total)
                    }
                }
            } catch _ {
                DispatchQueue.main.async {
                    self.presenter?.foundError(.Json)
                }
            }
        }.resume()
    }
    
    
}
