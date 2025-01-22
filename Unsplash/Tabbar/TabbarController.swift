//
//  TabbarController.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import UIKit

final class TabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabs = [TopicViewController(), RandomViewController(), SearchViewController()]
        
        for (i, tab) in tabs.enumerated() {
            tab.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: Constants.tabBarImages[i]), tag: i)
        }

        viewControllers = tabs.map { UINavigationController(rootViewController: $0) }

        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        tabBar.backgroundColor = .lightGray
        tabBar.tintColor = .black
    }
}
