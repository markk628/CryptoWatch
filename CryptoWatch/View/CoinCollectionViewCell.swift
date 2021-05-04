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
    
    //MARK: Views
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var coinIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
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
            $0.height.equalToSuperview().multipliedBy(0.5)
            $0.top.equalToSuperview().offset(10)
        }
        
        [coinNameLabel, coinCurrentPriceLabel].forEach {
            $0.snp.makeConstraints {
                $0.height.equalToSuperview().multipliedBy(0.25)
            }
        }
    }
    
    override func prepareForReuse() {
        coinIconImageView.image = nil
    }
}
