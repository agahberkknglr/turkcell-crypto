//
//  CoinService.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 5.05.2024.
//

import Foundation

class CoinService {
    
    func downloadCoins(completion: @escaping ([Coins]?) -> ()) {
        guard let url = URL(string: "https://psp-merchantpanel-service-sandbox.ozanodeme.com.tr/api/v1/dummy/coins") else { return }
        
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                completion(self.handelingData(data))
            case .failure(let error):
                self.handelingError(error)
            }
        }
    }
    private func handelingError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    private func handelingData(_ data: Data) -> [Coins]? {
        do {
            let coin = try JSONDecoder().decode(CoinData.self, from: data)
            return coin.data?.coins
        } catch {
            print(error)
            return nil
        }
    }
}
