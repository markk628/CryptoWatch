//
//  CoinTableViewCell.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/21/21.
//

import UIKit
import SnapKit

class CoinTableViewCell: UITableViewCell {
    
    //MARK: Views
    lazy var coinIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = false
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

//    let priceStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        return stackView
//    }()
    
    //MARK: Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCoinTableViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("error initiaizing coinTableViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCoinTableViewCell() {
        self.backgroundColor = .lightOxfordBlue
        self.addSubview(coinIconImageView)
        coinIconImageView.snp.makeConstraints {
            $0.width.equalTo(self.snp.height)
            $0.left.centerY.height.equalToSuperview()
        }
        
        self.addSubview(coinNameLabel)
        coinNameLabel.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.centerX.centerY.equalToSuperview()
        }
        
        self.addSubview(coinCurrentPriceLabel)
        coinCurrentPriceLabel.snp.makeConstraints {
            $0.left.equalTo(coinNameLabel.snp.right)
            $0.right.centerY.height.equalToSuperview()
        }
    }

}
