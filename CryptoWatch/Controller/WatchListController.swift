//
//  WatchListController.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/17/21.
//

import UIKit
import CoreData

class WatchListController: UIViewController, CryptoPriceDelegate {
    //MARK: Properties
    var coordinator: TabBarCoordinator!
    
    lazy var fetchedResultsController: NSFetchedResultsController<MyCoin> = {
        let fetchRequest: NSFetchRequest<MyCoin> = MyCoin.fetchRequest()
        fetchRequest.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    

//    private var filteredCoins: [Coin]!

    //MARK: Views
//    private lazy var coinSearchController: UISearchController = {
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchBar.placeholder = "Search coins"
//        searchController.searchBar.delegate = self
//        return searchController
//    }()
    
    lazy var coinTableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 120
        table.separatorStyle = .none
        table.allowsSelectionDuringEditing = true
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        table.register(CoinTableViewCell.self, forCellReuseIdentifier: Constants.coinTableViewCellIdentifier)
        return table
    }()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchResults()
        WebSocketService.shared.cryptoPriceDelegate = self
        WebSocketService.shared.connect()
        WebSocketService.shared.coins = fetchedResultsController.fetchedObjects ?? []
        
    }
    
    //MARK: Methods
    private func setupViews() {
        self.title = "Watch List"
        self.view.backgroundColor = .cwBlack
//        self.navigationItem.searchController = coinSearchController
        self.view.addSubview(coinTableView)
        coinTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func fetchResults() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Error fetching coins from Core Data \(error)")
        }
    }
    
    private func configureCell(cell: UITableViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? CoinTableViewCell else { return }
        let coin = fetchedResultsController.object(at: indexPath)
        
        cell.coinIconImageView.kf.setImage(with: URL(string: coin.icon ?? Constants.imageForCoinWithNoImage), placeholder: nil, options: nil) { (receivedSize, totalSize) in
            
        } completionHandler: { (result) in
            do {
                let _ = try result.get()
            } catch {
                DispatchQueue.main.async {
                    print("Downloaded images")
                }
            }
        }
        cell.coinNameLabel.text = coin.name ?? coin.assetId
        cell.coinCurrentPriceLabel.text = "$\(coin.currentPrice)"
    }
    
    func reloadTable() { print("\(WebSocketService.shared.price)") }
}

//MARK: Extensions
//MARK: Searchbar
//extension WatchListController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredCoins = []
//
//        if searchText.isEmpty {
//            filteredCoins = coins
//        } else {
//            for coin in coins {
//                if coin.name?.lowercased().contains(searchText.lowercased()) ?? false || coin.asset_id.lowercased().contains(searchText.lowercased()) {
//                    filteredCoins.append(coin)
//                }
//            }
//            coins = filteredCoins
//        }
//        self.coinTableView.reloadData()
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        fetchResults()
//    }
//}

//MARK: TableView
extension WatchListController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        coinTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            coinTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            coinTableView.deleteRows(at: [indexPath!], with: .automatic)
//            WebSocketService.shared.connect()
//            WebSocketService.shared.coins = fetchedResultsController.fetchedObjects ?? []
        case .update:
            let cell = coinTableView.cellForRow(at: indexPath!) as! CoinTableViewCell
            configureCell(cell: cell, for: indexPath!)

        case .move:
            coinTableView.deleteRows(at: [indexPath!], with: .automatic)
            coinTableView.insertRows(at: [newIndexPath!], with: .automatic)
        @unknown default:
            fatalError("Error handling watch list coin table cells")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        coinTableView.endUpdates()
    }
}

extension WatchListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = fetchedResultsController.object(at: indexPath)
        let popup = TargetPricePopupController()
        popup.coin = coin
        self.addChild(popup)
        popup.view.frame = self.view.frame
        self.view.addSubview(popup.view)
        popup.didMove(toParent: self)
    }
}

extension WatchListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0}
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.coinTableViewCellIdentifier, for: indexPath) as! CoinTableViewCell
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                self.configureCell(cell: cell, for: indexPath)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {
            CoreDataStack.shared.mainContext.delete(fetchedResultsController.object(at: indexPath))
            CoreDataStack.shared.saveContext()
            WebSocketService.shared.connect()
            WebSocketService.shared.coins = fetchedResultsController.fetchedObjects ?? []
        } else if editingStyle == .insert {
            WebSocketService.shared.connect()
            WebSocketService.shared.coins = fetchedResultsController.fetchedObjects ?? []
        }
    }
}
