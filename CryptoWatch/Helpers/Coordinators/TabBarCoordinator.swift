//
//  TabBarCoordinator.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/17/21.
//

import UIKit

class TabBarCoordinator: NSObject, UITabBarControllerDelegate, Coordinator {
    
    //MARK: Properties
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var coinCollectionNavigationController: UINavigationController!
    var watchListNavigationController: UINavigationController!
    var tabBarController = TabBarController()
    
    //MARK: Initialize
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: Methods
    func start() {
        tabBarController.coordinator = self
        tabBarController.delegate = self
        
        let coinCollectionController = CoinCollectionController()
        coinCollectionController.coordinator = self
        coinCollectionNavigationController = UINavigationController(rootViewController: coinCollectionController)
        coinCollectionNavigationController.tabBarItem = UITabBarItem(title: "Coins", image: UIImage(systemName: "bitcoinsign.circle"), tag: 0)
        
        let watchListController = WatchListController()
        watchListController.coordinator = self
        watchListNavigationController = UINavigationController(rootViewController: watchListController)
        watchListNavigationController.tabBarItem = UITabBarItem(title: "WatchList", image: UIImage(systemName: "eye"), tag: 1)
        
        tabBarController.viewControllers = [coinCollectionNavigationController, watchListNavigationController]
        
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.setupNavigationController()
        navigationController.present(tabBarController, animated: false, completion: nil)
    }
}
