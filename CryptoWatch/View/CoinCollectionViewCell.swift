//
//  CoinCollectionViewCell.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/18/21.
//

import UIKit
import SnapKit

class CoinCollectionViewCell: UICollectionViewCell {
    
    //MARK: Poperties
//    var details: Coin? {
//        didSet {
//            guard let details = self.details else { return }
////            let coinImageUrl = URL(string: <#T##String#>)
//            coinNameLabel.text = details.name
////            coinCurrentPriceLabel.text = "\(details.price_usd)"
//        }
//    }
    
    //MARK: Views
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var coinIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
//    lazy var coinIdLabel: UILabel = {
//        let label = UILabel()
//        label.text = "BTC"
//        label.textAlignment = .center
//        return label
//    }()
    
    lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    lazy var coinCurrentPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCoinCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("error initializing coinCollectionViewCell")
    }
    
    //MARK: Methods
    func setupCoinCollectionViewCell() {
        self.backgroundColor = .lightOxfordBlue
//        self.layer.cornerRadius = 10.0
        self.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [coinIconImageView, coinNameLabel, coinCurrentPriceLabel].forEach {
            mainStackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
            }
        }
        
        coinIconImageView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.64)
//            $0.width.equalTo(mainStackView).multipliedBy(0.3)
        }
        
        [coinNameLabel, coinCurrentPriceLabel].forEach {
            $0.snp.makeConstraints {
                $0.height.equalToSuperview().multipliedBy(0.18)
            }
        }
//        
//        coinIdLabel.snp.makeConstraints {
//            $0.height.equalTo(30)
//        }
    }
    
    override func prepareForReuse() {
        coinIconImageView.image = nil
    }
}
