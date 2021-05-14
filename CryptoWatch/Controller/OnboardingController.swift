//
//  OnboardingController.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/17/21.
//

import UIKit
import SnapKit

class OnboardingController: UIViewController {
    
    //MARK: Properties
    var coordinator: AppCoordinator!
//    let center: UNUserNotificationCenter = {
//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
//            // do something do nothing idc
//        }
//        return center
//    }()
    
    //MARK: Views
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "CryptoWatchLogo")
        return imageView
    }()
    
    private let watchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Watch", for: .normal)
        button.setTitleColor(.blueNCS, for: .normal)
        button.addTarget(self, action: #selector(watchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        cWNotification.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // do something do nothing idc
        }
    }
    
    //MARK: Methods
    private func setupViews() {
        self.view.backgroundColor = .cwBlack
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.height.width.equalTo(150)
            $0.center.equalToSuperview()
        }
        
        self.view.addSubview(watchButton)
        watchButton.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
    
    @objc func watchButtonTapped() {
        coordinator.goToCoinCollectionController()
    }
}
