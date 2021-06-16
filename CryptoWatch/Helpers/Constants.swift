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
    
    static let imageForCoinWithNoImage: String = "https://chronicle.brightspotcdn.com/dims4/default/3bb9fc2/2147483647/strip/true/crop/625x401+0+0/resize/1680x1078!/format/webp/quality/90/?url=http%3A%2F%2Fchronicle-brightspot.s3.amazonaws.com%2F89%2F74%2F4b46fe3effe1e4f0fa4ce534f383%2Fnothing-to-see-15a34a2fc727c8.jpg"
}

public let cWNotification = UNUserNotificationCenter.current()

