//
//  File.swift
//  NShopping
//
//  Created by ilim on 2025-01-15.
//

import UIKit

extension UITableViewCell {
    static func getId() -> String {
        return String(describing: self)
    }
    
    func flowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let numberOfItemsInLine: CGFloat = 2
        let inset: CGFloat = 5
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - (numberOfItemsInLine + 1) * inset) / numberOfItemsInLine
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = inset
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        return layout
    }
}
