//
//  TabBarController.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/17/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    //MARK: Properties
    var coordinator: TabBarCoordinator!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        setupTabBarController()
    }
}

//MARK: Methods
extension TabBarController {
    func setupNavigationController() {
        for i in 0...1 {
            guard let navVC = self.viewControllers?[i] as? UINavigationController else { return }
            navVC.navigationBar.prefersLargeTitles = true
            navVC.navigationBar.barTintColor = .cwBlack
            navVC.navigationBar.tintColor = .blueNCS
            navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blueNCS]
            navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blueNCS]
        }
    }
    
    func setupTabBarController() {
        self.tabBar.barTintColor = .cwBlack
        self.tabBar.tintColor = .blueNCS
    }
}
