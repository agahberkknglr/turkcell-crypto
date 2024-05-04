//
//  CoinData.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 4.05.2024.
//

import Foundation

struct CoinData: Decodable {
    let status: String
    let data: Data
}

struct Data: Decodable {
    let coins: [Coins]
}

struct Coins: Decodable {
    let symbol, name, color, iconUrl, marketCap, price, change, coinrankingUrl, volume24h, btcPrice: String?
    let listedAt, tier, rank: Int?
    let lowVolume: Bool?
    
    enum CodingKeys: String, CodingKey {
        case symbol, name, color, iconUrl, marketCap, price, change, coinrankingUrl, btcPrice
        case volume24h = "24hVolume"
        case listedAt, tier, rank
        case lowVolume
    }
}
