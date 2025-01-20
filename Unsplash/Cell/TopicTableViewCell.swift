//
//  TopicTableViewCell.swift
//  Unsplash
//
//  Created by ilim on 2025-01-19.
//

import UIKit

class TopicTableViewCell: BaseTableViewCell {
    
    weak var delegate: sendData?
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout())
    
    private var result: [Photo] = [] {
        didSet {
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .left, animated: false)
        }
    }
    
    static let id = getId()
    
    override func configureHierarchy() {
        addSubView(collectionView)
        initCollectionView()
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension TopicTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let item = result[row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.id, for: indexPath) as! SearchCollectionViewCell
        
        cell.configureData(item)
        
        DispatchQueue.main.async {
            cell.contentView.layer.cornerRadius = 20
            cell.contentView.clipsToBounds = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let tag = collectionView.tag
        let row = indexPath.item
        delegate?.sendData(tag, row)
    }
}

extension TopicTableViewCell {
    func configureData(_ item: [Photo]) {
        result = item
    }
    
    private func initCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
    }
}
