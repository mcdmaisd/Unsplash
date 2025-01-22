//
//  CustomSwitch.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import UIKit

final class CustomSwitch: UISwitch {
    
    private let color: UIColor
    private let switchTag: Int

    init(color: UIColor, tag: Int) {
        self.color = color
        self.switchTag = tag
        super.init(frame: .zero)
        configureSwitch()
    }
    
    private func configureSwitch() {
        isOn = false
        onTintColor = .gray
        thumbTintColor = color
        tag = switchTag
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
