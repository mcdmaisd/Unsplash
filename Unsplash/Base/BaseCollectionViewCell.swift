//
//  BaseCollectionViewCell.swift
//  NShopping
//
//  Created by ilim on 2025-01-17.
//

import UIKit
import Kingfisher
import SnapKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .gray
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {}
    func configureLayout() {}
    func configureView() {}
    func addSubView(_ view: UIView) {
        self.contentView.addSubview(view)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
