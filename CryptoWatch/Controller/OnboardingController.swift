//
//  OnboardingController.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/17/21.
//

import UIKit
import SnapKit

class OnboardingController: UIViewController {
    
    //MARK: Views
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "CryptoWatchLogo")
        return imageView
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
    }
}
