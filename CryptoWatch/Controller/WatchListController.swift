//
//  WatchListController.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/17/21.
//

import UIKit
import CoreData

class WatchListController: UIViewController {

    //MARK: Properties
    var coordinator: TabBarCoordinator!
    
    lazy var fetchedResultsController: NSFetchedResultsController<MyCoin> = {
        let fetchRequest: NSFetchRequest<MyCoin> = MyCoin.fetchRequest()
        fetchRequest.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private var coins: [Coin] = [] {
        didSet {
            self.coinTableView.reloadData()
        }
    }
    
    private var filteredCoins: [Coin]!

    //MARK: Views
    private lazy var coinSearchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search coins"
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    lazy var coinTableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 100
//        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.allowsSelectionDuringEditing = true
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        table.register(CoinTableViewCell.self, forCellReuseIdentifier: Constants.coinTableViewCellIdentifier)
        return table
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshCoinTable), for: .valueChanged)
        return refresh
    }()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchResults()
    }
    
    //MARK: Methods
    private func setupViews() {
        self.title = "Watch List"
        self.view.backgroundColor = .cwBlack
        self.navigationItem.searchController = coinSearchController
        self.view.addSubview(coinTableView)
        coinTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func fetchResults() {
        do {
            try fetchedResultsController.performFetch()
            self.refreshControl.endRefreshing()
        } catch {
            fatalError("Error fetching coins from Core Data \(error)")
        }
    }
    
    private func configureCell(cell: UITableViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? CoinTableViewCell else { return }
        let coin = fetchedResultsController.object(at: indexPath)
        
        cell.coinIconImageView.kf.setImage(with: URL(string: coin.icon ?? "https://chronicle.brightspotcdn.com/dims4/default/3bb9fc2/2147483647/strip/true/crop/625x401+0+0/resize/1680x1078!/format/webp/quality/90/?url=http%3A%2F%2Fchronicle-brightspot.s3.amazonaws.com%2F89%2F74%2F4b46fe3effe1e4f0fa4ce534f383%2Fnothing-to-see-15a34a2fc727c8.jpg"), placeholder: nil, options: nil) { (receivedSize, totalSize) in
            
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
    }
    
    @objc func refreshCoinTable() {
        fetchResults()
    }
}

//MARK: Extensions
//MARK: Searchbar
extension WatchListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCoins = []

        if searchText.isEmpty {
            filteredCoins = coins
        } else {
            for coin in coins {
                if coin.name?.lowercased().contains(searchText.lowercased()) ?? false || coin.asset_id.lowercased().contains(searchText.lowercased()) {
                    filteredCoins.append(coin)
                }
            }
            coins = filteredCoins
        }
        self.coinTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchResults()
    }
}

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
        // modal/popup/whatever
        let vc = CoinController()
        vc.coin = coin
        self.present(vc, animated: true, completion: nil)
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
        if editingStyle == .delete {
            CoreDataStack.shared.mainContext.delete(fetchedResultsController.object(at: indexPath))
            CoreDataStack.shared.saveContext()
        }
    }
}
