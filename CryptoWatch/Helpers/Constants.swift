//
//  Constants.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/18/21.
//

import Foundation
import UserNotifications

struct Constants {
    static let coinCollectionViewCellIdentifier: String = "CoinCollectionViewCell"
    static let coinTableViewCellIdentifier: String = "CoinTableViewCell"
    
    static let baseURL: String = "https://rest.coinapi.io/"
    static let assetListURL: String = "https://rest.coinapi.io/v1/assets"
    static let assetIconURL: String = "https://rest.coinapi.io/v1/assets/icons"
    
    static let baseWebSocketURL: String = "wss://ws.finnhub.io"
}

public let cWNotification = UNUserNotificationCenter.current()

