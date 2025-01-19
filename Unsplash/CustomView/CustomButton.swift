//
//  CustomButton.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureButton()
    }
    
    private func configureButton() {
        var config = UIButton.Configuration.filled()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 20)

        config.buttonSize = .small
        config.background.strokeColor = .black

        self.configuration = config
        self.sizeToFit()
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.configurationUpdateHandler = { btn in
            switch btn.state {
            case .selected:
                btn.configuration?.attributedTitle = AttributedString("최신순", attributes: titleContainer)
                btn.configuration?.baseBackgroundColor = .black
                btn.configuration?.baseForegroundColor = .white
            default:
                btn.configuration?.attributedTitle = AttributedString("관련순", attributes: titleContainer)
                btn.configuration?.baseBackgroundColor = .white
                btn.configuration?.baseForegroundColor = .black
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
