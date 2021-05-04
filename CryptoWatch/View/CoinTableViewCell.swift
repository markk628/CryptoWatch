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
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .lightOxfordBlue
        return stackView
    }()
    
    lazy var coinIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = false
        return imageView
    }()
    
    lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var coinCurrentPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "some shit"
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
        self.backgroundColor = .clear
        self.addSubview(mainStackView)
//        self.addSubview(coinIconImageView)
        
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        [coinIconImageView, coinNameLabel, coinCurrentPriceLabel].forEach {
            mainStackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.bottom.equalToSuperview().offset(-10)
            }
        }
    
        coinIconImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
        }
        
        coinNameLabel.snp.makeConstraints {
            $0.left.equalTo(coinIconImageView.snp.right).offset(15)
        }
        
        coinCurrentPriceLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
        }
    }

}
