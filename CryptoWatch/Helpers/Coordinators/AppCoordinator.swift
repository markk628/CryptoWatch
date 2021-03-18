//
//  AppCoordinator.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/17/21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    lazy var navigationController: UINavigationController = UINavigationController()
    
    init(window: UIWindow) {
        window.rootViewController = navigationController
        setupNavigationController()
    }
    
    func start() {
        let vc = OnboardingController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToCoinController() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.start()
    }
}

private extension AppCoordinator {
    func setupNavigationController() {
        self.navigationController.isNavigationBarHidden = true
    }
}
