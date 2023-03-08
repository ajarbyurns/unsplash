//
//  ItemCell.swift
//  UnsplashTest
//
//  Created by bitocto_Barry on 08/03/23.
//

import UIKit

protocol ItemCellToItemPresenter : AnyObject{
    var view : ItemPresenterToItemCell? { get set }
    func loadImage()
}

class ItemCell: UICollectionViewCell {
    
    var loading : UIActivityIndicatorView
    var imageView: UIImageView
    var content : UIView
    
    var presenter : ItemCellToItemPresenter?{
        didSet{
            presenter?.view = self
            presenter?.loadImage()
        }
    }
    
    override init(frame : CGRect){
        self.loading = UIActivityIndicatorView(style: .large)
        self.imageView = UIImageView()
        self.content = UIView()
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews(){
        
        backgroundColor = .lightGray
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        loading.color = .black
        addSubview(loading)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loading.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loading.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loading.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loading.hidesWhenStopped = false
        loading.startAnimating()
        
        content.backgroundColor = .clear
        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        content.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        content.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: content.widthAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
                
    }
     
    required init?(coder: NSCoder) {
        fatalError("Not In Storyboard")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loading.isHidden = false
        loading.startAnimating()
        imageView.image = nil
    }
    
    
}

extension ItemCell : ItemPresenterToItemCell {
    
    func imageLoaded(_ imageData: Data) {
        imageView.image = UIImage(data: imageData)
        loading.isHidden = true
    }
    
    func foundError(_ error: ApiError) {
        switch error {
        case .URL:
            print("URL Error")
        case .Connection:
            print("Connection Error")
        case .Json:
            print("JSON Error")
        }
    }
    
    
}
