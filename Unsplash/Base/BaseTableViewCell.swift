//
//  BaseCell.swift
//  NShopping
//
//  Created by ilim on 2025-01-17.
//

import UIKit
import Kingfisher
import SnapKit

class BaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
