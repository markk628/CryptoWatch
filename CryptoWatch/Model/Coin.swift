//
//  Coin.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/18/21.
//

import Foundation

struct Coin: Decodable {
    let asset_id: String
    let name: String?
    let type_is_crypto: Int
    let price_usd: Double?
}

struct Icon: Decodable {
    let asset_id: String
    let url: String
}
