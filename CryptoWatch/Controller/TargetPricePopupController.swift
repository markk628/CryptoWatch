//
//  TargetPricePopupController.swift
//  CryptoWatch
//
//  Created by Mark Kim on 5/3/21.
//

import UIKit

class TargetPricePopupController: UIViewController {
    
    var coin: MyCoin!
        
    let popupView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .lightOxfordBlue
        return view
    }()
    
    lazy var coinIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = false
        return imageView
    }()
    
    lazy var coinIDLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = coin.assetId
        return label
    }()
    
    lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = coin.name
        return label
    }()
    
    lazy var coinCurrentPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
        
    lazy var coinTargetPriceLabel: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.keyboardType = .decimalPad
        textField.backgroundColor = .white
        textField.textColor = .oxfordBlue
        textField.text = String(coin.targetPrice)
        return textField
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.blueNCS, for: .normal)
        button.addTarget(self, action: #selector(saveTargetPrice), for: .touchUpInside)
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.blueNCS, for: .normal)
        button.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getCoin()
    }
    
    fileprivate func setupBackground() {
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
    fileprivate func setupViews() {
        setupBackground()
        animatePopup()
        
        view.addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.5)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.centerX.centerY.equalToSuperview()
        }
        
        popupView.addSubview(coinIconImageView)
        coinIconImageView.snp.makeConstraints {
            $0.height.width.equalTo(150)
            $0.top.equalToSuperview().offset(25)
            $0.centerX.equalToSuperview()
        }
        coinIconImageView.kf.setImage(with: URL(string: coin.icon ?? "https://chronicle.brightspotcdn.com/dims4/default/3bb9fc2/2147483647/strip/true/crop/625x401+0+0/resize/1680x1078!/format/webp/quality/90/?url=http%3A%2F%2Fchronicle-brightspot.s3.amazonaws.com%2F89%2F74%2F4b46fe3effe1e4f0fa4ce534f383%2Fnothing-to-see-15a34a2fc727c8.jpg"), placeholder: nil, options: nil) { (receivedSize, totalSize) in
        } completionHandler: { (result) in
            do {
                let _ = try result.get()
            } catch {
                DispatchQueue.main.async {
                    print("Downloaded image")
                }
            }
        }
        
        popupView.addSubview(coinIDLabel)
        coinIDLabel.snp.makeConstraints {
            $0.width.equalTo(coinIconImageView)
            $0.height.equalTo(30)
            $0.top.equalTo(coinIconImageView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        popupView.addSubview(coinNameLabel)
        coinNameLabel.snp.makeConstraints {
            $0.width.equalTo(coinIconImageView)
            $0.height.equalTo(30)
            $0.top.equalTo(coinIDLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        popupView.addSubview(coinCurrentPriceLabel)
        coinCurrentPriceLabel.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(30)
            $0.top.equalTo(coinNameLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        popupView.addSubview(coinTargetPriceLabel)
        coinTargetPriceLabel.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(30)
            $0.top.equalTo(coinCurrentPriceLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        popupView.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(30)
            $0.top.equalTo(coinTargetPriceLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        popupView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(30)
            $0.top.equalTo(saveButton.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
    }
    
    fileprivate func animatePopup() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    fileprivate func removePopup() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: { (finished: Bool) in
            if finished {
                self.view.removeFromSuperview()
            }
        })
    }
    
    @objc fileprivate func closePopup() {
        removePopup()
    }
    
    @objc private func saveTargetPrice() {
        guard let target = coinTargetPriceLabel.text else { return }
        coin.targetPrice = Double(target)!
        CoreDataStack.shared.saveContext()
        view.endEditing(true)
        showSavedCoinAlert()
    }
    
    private func getCoin() {
        NetworkManager.shared.getCoin(coin: coin.assetId!) { (result) in
            switch result {
            case let .success(pulledCoin):
                if let coinId = self.coin.assetId {
                    self.coinCurrentPriceLabel.text = "$\(round(1000 * (pulledCoin.first?.price_usd!)!) / 1000)/\(String(describing: coinId))"
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func showSavedCoinAlert() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
