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
    var coinNavigationController: UINavigationController!
    var notificationsNavigationController: UINavigationController!
    var tabBarController = TabBarController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        tabBarController.coordinator = self
        tabBarController.delegate = self
        
        let coinController = CoinController()
        coinController.coordinator = self
        coinNavigationController = UINavigationController(rootViewController: coinController)
        coinNavigationController.tabBarItem = UITabBarItem(title: "Coins", image: UIImage(systemName: "bitcoinsign.circle"), tag: 0)
        
        let notificationsController = NotificationsController()
        notificationsController.coordinator = self
        notificationsNavigationController = UINavigationController(rootViewController: notificationsController)
        notificationsNavigationController.tabBarItem = UITabBarItem(title: "Watch", image: UIImage(systemName: "eye"), tag: 1)
        
        tabBarController.viewControllers = [coinNavigationController, notificationsNavigationController]
        
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.setupNavigationController()
        navigationController.present(tabBarController, animated: false, completion: nil)
    }
}
