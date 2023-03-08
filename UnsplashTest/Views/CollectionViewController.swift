//
//  CollectionViewController.swift
//  UnsplashTest
//
//  Created by bitocto_Barry on 08/03/23.
//

import Foundation
import UIKit

protocol CollectionViewToCollectionPresenter : AnyObject{
    var view : CollectionPresenterToCollectionView? {get set}
    func getItems(_ query : String?)
    func getItemCount() -> Int
    func getMoreItems(_ query : String?)
    func findItem(_ index : Int) -> Item?
}

class CollectionViewController: UIViewController {
        
    var presenter : CollectionViewToCollectionPresenter?
    let searchTextField : UITextField
    let divider : UIView
    var collectionView : UICollectionView?
    
    init(){
        self.divider = UIView()
        searchTextField = UITextField()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not in Storyboard")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.itemSize = CGSize(width: view.frame.width/CGFloat(cellsPerRow) - (2 * inset), height: view.frame.height/4)
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
    
        if let collectionView = self.collectionView {
            collectionView.backgroundColor = .white
            view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.topAnchor.constraint(equalTo: divider.bottomAnchor).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            collectionView.register(ItemCell.self, forCellWithReuseIdentifier: cellId)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        let searchView = UIView()
        searchView.layer.cornerRadius = 10
        searchView.backgroundColor = .lightGray
        view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        let searchImage = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchImage.tintColor = .white
        searchView.addSubview(searchImage)
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        searchImage.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 10).isActive = true
        searchImage.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 10).isActive = true
        searchImage.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: -10).isActive = true
        searchImage.widthAnchor.constraint(equalTo: searchImage.heightAnchor, multiplier: 1).isActive = true

        searchView.addSubview(searchTextField)
        searchTextField.keyboardType = .webSearch
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.leadingAnchor.constraint(equalTo: searchImage.trailingAnchor, constant: 10).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -10).isActive = true
        searchTextField.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 10).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: -10).isActive = true
        searchTextField.delegate = self
        
        divider.backgroundColor = .lightGray
        view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        divider.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10).isActive = true
    }

}

extension CollectionViewController : CollectionPresenterToCollectionView {
    
    func itemsSet() {
        collectionView?.reloadData()
    }
    
    func foundError(_ error: ApiError) {
        switch error {
        case .Connection:
            print("Connection Error")
        case .URL:
            print("URL Error")
        case .Json:
            print("JSON Error")
        }
    }
    
    func noMorePages() {
        print("All Pages Loaded")
    }

}


extension CollectionViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter?.getItems(textField.text)
        collectionView?.setContentOffset(CGPoint(x:0,y:0), animated: false)
    }
    
}

extension CollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    var inset: CGFloat {
        get { return 10 }
    }
    var cellsPerRow : Int {
        get { return 2 }
    }
    var cellId : String {
        get { return "ItemCell" }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getItemCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.row == (presenter?.getItemCount() ?? 0) - 1) {
            presenter?.getMoreItems(searchTextField.text)
        }
                        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ItemCell ?? ItemCell(frame : CGRect())
        if let item = presenter?.findItem(indexPath.row){
            cell.presenter?.view = nil
            cell.presenter = ItemPresenter(item, ItemInteractor())
        }
        cell.layoutIfNeeded()
        return cell
    }
    
}
