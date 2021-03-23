//
//  CoinCollectionController.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/17/21.
//

import UIKit
import SnapKit
import Kingfisher

class CoinCollectionController: UIViewController {
    
    //MARK: Properties
    var coordinator: TabBarCoordinator!
    private let networkManager = NetworkManager()
    
    private var coins: [Coin] = [] {
        didSet {
            self.coinCollectionView.reloadData()
        }
    }
    
    private var icons: [Icon] = [] //{
//        didSet {
//            self.coinCollectionView.reloadData()
//        }
//    }
    
    private var filteredCoins: [Coin]!
    
    //MARK: Views
    private lazy var coinSearchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search coins"
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    lazy var coinCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(CoinCollectionViewCell.self, forCellWithReuseIdentifier: Constants.coinCollectionViewCellIdentifier)
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshCoinCollection), for: .valueChanged)
        return refresh
    }()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getCoins()
    }
    
    //MARK: Methods
    private func setupViews() {
        self.title = "Coins"
        self.view.backgroundColor = .cwBlack
        self.navigationItem.searchController = coinSearchController
        self.view.addSubview(coinCollectionView)
        coinCollectionView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
            $0.right.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func getCoins() {
        networkManager.getCoins { (result) in
            switch result {
            case let .success(pulledCoins):
                self.coins = pulledCoins.filter { $0.type_is_crypto == 1}
                self.coins.sort { $0.price_usd ?? 0 > $1.price_usd ?? 0 }
                DispatchQueue.main.async {
                    self.coinCollectionView.reloadData()
                }
                self.refreshControl.endRefreshing()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func configureCell(cell: UICollectionViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? CoinCollectionViewCell else { return }
        let coin = coins[indexPath.row]
        
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                self.networkManager.getCoinIcons { (result) in
                    switch result {
                    case let .success(pulledIcons):
                        self.icons = pulledIcons
                        for icon in pulledIcons {
                            if icon.asset_id == coin.asset_id {
                                let imageUrl = URL(string: icon.url)
                                cell.coinIconImageView.kf.setImage(with: imageUrl, placeholder: nil, options: nil) { (receivedSize, totalSize) in
                                    
                                } completionHandler: { (result) in
                                    do {
                                        let _ = try result.get()
                                    } catch {
                                        DispatchQueue.main.async {
                                            print("Downloaded images")
                                        }
                                    }
                                }
                                
                                
                            }
                        }
                    case let .failure(error):
                        print(error)
                    }
                }
            }
        }
        
        cell.coinNameLabel.text = coin.name ?? coin.asset_id
        guard let currentPrice = coin.price_usd else { return }
        cell.coinCurrentPriceLabel.text = "$\(round(1000 * currentPrice) / 1000)/\(coin.asset_id)"
    }
    
    private func saveCoinToWatchList(cell: UICollectionViewCell, for indexPath: IndexPath) {
        guard cell is CoinCollectionViewCell else { return }
        let coin = coins[indexPath.row]
        let newCoin = MyCoin(context: CoreDataStack.shared.mainContext)
        newCoin.assetId = coin.asset_id
        newCoin.name = coin.name
//        newCoin.icon = cell.coinIconImageView.image
        for icon in icons {
            if icon.asset_id == coin.asset_id {
                newCoin.icon = icon.url
            }
        }
        CoreDataStack.shared.saveContext()
        print("saved")
    }
    
    @objc func refreshCoinCollection() {
        getCoins()
    }
}

extension CoinCollectionController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCoins = []
        
        if searchText.isEmpty {
            filteredCoins = coins
            //            getCoins()
        } else {
            for coin in coins {
                if coin.name?.lowercased().contains(searchText.lowercased()) ?? false || coin.asset_id.lowercased().contains(searchText.lowercased()) {
                    filteredCoins.append(coin)
                }
            }
            coins = filteredCoins
        }
        self.coinCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getCoins()
    }
}

extension CoinCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.1, height: collectionView.frame.width/2.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
    }
}

extension CoinCollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.coinCollectionViewCellIdentifier, for: indexPath) as! CoinCollectionViewCell
        //        DispatchQueue.global(qos: .userInteractive).async {
        DispatchQueue.main.async {
            self.configureCell(cell: cell, for: indexPath)
        }
        //        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        saveCoinToWatchList(cell: collectionView.cellForItem(at: indexPath)!, for: indexPath)
    }
}
