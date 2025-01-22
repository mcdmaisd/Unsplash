//
//  UICollectionView+Extension.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import UIKit

extension UIViewController {
    func flowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let numberOfItemsInLine: CGFloat = 2
        let inset: CGFloat = 5
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - (numberOfItemsInLine + 1) * inset) / numberOfItemsInLine
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = inset
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        return layout
    }
    
    func presentAlert(message: String?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.okActionTitle, style: .default))
        present(alert, animated: true)
    }
    
    @objc
    private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureNavigationBar(_ vc: UIViewController) {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(back))
        let image = UIImage(systemName: Constants.backImageName)
        
        backBarButtonItem.tintColor = .black
        backBarButtonItem.image = image
        vc.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func makeNavigationBarTransparent() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
