//
//  CoinController.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/23/21.
//

import UIKit
import SnapKit
import Kingfisher

//class CoinController: UIViewController {
//    
//    var coin: MyCoin!
//    
//    //MARK: Views
//    lazy var coinIconImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = .clear
//        imageView.contentMode = .scaleToFill
//        imageView.layer.masksToBounds = false
//        return imageView
//    }()
//    
//    lazy var coinNameLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        return label
//    }()
//    
//    lazy var coinIDLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        return label
//    }()
//    
////    lazy var dateAddedLabel: UILabel = {
////        let label = UILabel()
////        label.textAlignment = .center
////        return label
////    }()
////
////    lazy var priceWhenAddedLabel: UILabel = {
////        let label = UILabel()
////        label.textAlignment = .center
////        return label
////    }()
//    
//    lazy var coinCurrentPriceLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        return label
//    }()
//    
//    lazy var coinTargetPriceLabel: UITextField = {
//        let textField = UITextField()
//        textField.textAlignment = .center
//        textField.returnKeyType = .done
//        textField.keyboardType = .decimalPad
//        textField.backgroundColor = .white
//        textField.textColor = .oxfordBlue
//        textField.text = String(coin.targetPrice) 
//        return textField
//    }()
//    
//    lazy var saveButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Save", for: .normal)
//        button.setTitleColor(.blueNCS, for: .normal)
//        button.addTarget(self, action: #selector(saveTargetPrice), for: .touchUpInside)
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//        getCoin()
//    }
//    
//    private func setupViews() {
//        self.view.backgroundColor = .cwBlack
//        self.view.addSubview(coinIconImageView)
//        coinIconImageView.snp.makeConstraints {
//            $0.width.height.equalTo(150)
//            $0.centerX.equalToSuperview()
//            $0.top.equalToSuperview().offset(50)
//        }
//        coinIconImageView.kf.setImage(with: URL(string: coin.icon ?? Constants.imageForCoinWithNoImage), placeholder: nil, options: nil) { (receivedSize, totalSize) in
//        } completionHandler: { (result) in
//            do {
//                let _ = try result.get()
//            } catch {
//                DispatchQueue.main.async {
//                    print("Downloaded image")
//                }
//            }
//        }
//        
//        self.view.addSubview(coinIDLabel)
//        coinIDLabel.snp.makeConstraints {
//            $0.width.equalTo(coinIconImageView)
//            $0.height.equalTo(30)
//            $0.top.equalTo(coinIconImageView.snp.bottom).offset(15)
//            $0.centerX.equalToSuperview()
//        }
//        coinIDLabel.text = coin.assetId
//        
//        self.view.addSubview(coinNameLabel)
//        coinNameLabel.snp.makeConstraints {
//            $0.width.equalTo(coinIconImageView)
//            $0.height.equalTo(30)
//            $0.top.equalTo(coinIDLabel.snp.bottom).offset(15)
//            $0.centerX.equalToSuperview()
//        }
//        coinNameLabel.text = coin.name
//        
////        self.view.addSubview(dateAddedLabel)
////        dateAddedLabel.snp.makeConstraints {
////            $0.width.equalTo(coinIconImageView)
////            $0.height.equalTo(30)
////            $0.top.equalTo(coinNameLabel.snp.bottom).offset(15)
////            $0.centerX.equalToSuperview()
////        }
////
////        self.view.addSubview(priceWhenAddedLabel)
////        priceWhenAddedLabel.snp.makeConstraints {
////            $0.width.equalTo(coinIconImageView)
////            $0.height.equalTo(30)
////            $0.top.equalTo(dateAddedLabel.snp.bottom).offset(15)
////            $0.centerX.equalToSuperview()
////        }
//        
//        self.view.addSubview(coinCurrentPriceLabel)
//        coinCurrentPriceLabel.snp.makeConstraints {
//            $0.width.equalToSuperview().multipliedBy(0.8)
//            $0.height.equalTo(30)
//            $0.top.equalTo(coinNameLabel.snp.bottom)
//            $0.centerX.equalToSuperview()
//        }
//        
//        self.view.addSubview(coinTargetPriceLabel)
//        coinTargetPriceLabel.snp.makeConstraints {
//            $0.width.equalToSuperview().multipliedBy(0.8)
//            $0.height.equalTo(30)
//            $0.top.equalTo(coinCurrentPriceLabel.snp.bottom).offset(10)
//            $0.centerX.equalToSuperview()
//        }
//        
//        self.view.addSubview(saveButton)
//        saveButton.snp.makeConstraints {
//            $0.width.equalToSuperview().multipliedBy(0.8)
//            $0.height.equalTo(30)
//            $0.top.equalTo(coinTargetPriceLabel.snp.bottom).offset(10)
//            $0.centerX.equalToSuperview()
//        }
//    }
//    
//    private func getCoin() {
//        NetworkManager.shared.getCoin(coin: coin.assetId!) { (result) in
//            switch result {
//            case let .success(pulledCoin):
////                self.coin = pulledCoin
//                if let coinId = self.coin.assetId {
//                    self.coinCurrentPriceLabel.text = "$\(round(1000 * (pulledCoin.first?.price_usd!)!) / 1000)/\(String(describing: coinId))"
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
//    }
//    
//    @objc private func saveTargetPrice() {
//        guard let target = coinTargetPriceLabel.text else { return }
//        coin.targetPrice = Double(target)!
//        CoreDataStack.shared.saveContext()
//        view.endEditing(true)
//        showSavedCoinAlert()
//    }
//    
//    private func sendNotification() {
//        
//    }
//    
//    private func showSavedCoinAlert() {
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
//    }
//}
