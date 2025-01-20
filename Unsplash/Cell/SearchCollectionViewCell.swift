//
//  SearchCollectionViewCell.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import UIKit

class SearchCollectionViewCell: BaseCollectionViewCell {
    
    private let thumbnail = UIImageView()
    private let outlineView = UIView()
    private let likeLabel = UILabel()
    private let likeButton = UIButton()
    
    static let id = getId()
    
    override func configureHierarchy() {
        addSubView(thumbnail)
        addSubView(outlineView)
        outlineView.addSubview(likeLabel)
    }
    
    override func configureLayout() {
        thumbnail.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        outlineView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    override func configureView() {
        thumbnail.contentMode = .scaleToFill
        contentView.isExclusiveTouch = true
        
        outlineView.backgroundColor = .gray
        outlineView.layer.cornerRadius = 15
        outlineView.clipsToBounds = true
        
        likeLabel.textAlignment = .center
        likeLabel.textColor = .white
        likeLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = nil
        likeLabel.text = nil
    }
    
    func configureData(_ photo: Photo) {
        thumbnail.kf.setImage(with: URL(string: photo.urls.regular))
        likeLabel.text = "\("⭐️ ")\(photo.likes.formatted())"
    }
}
