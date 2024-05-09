//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 5.05.2024.
//

import Foundation

enum SortingCriteria {
    case rank
    case price
    case listedAt
    case change
    case volume24h
    case marketCap
}

protocol HomeViewModelProtocol {
    var view: HomeScreenViewProtocol? { get set }
    
    func viewDidLoad()
    func getCoins()
    func viewWillAppear()
    func cycleSortingCriteria()
    func sortCoins()
    
}

final class HomeViewModel {
    weak var view: HomeScreenViewProtocol?
    private let service = CoinService()
    var coins = [Coins]()
    var sortingCriteria: SortingCriteria = .rank
}



extension HomeViewModel: HomeViewModelProtocol {
    
    func viewDidLoad() {
        getCoins()
    }
    
    func viewWillAppear() {
        view?.configureHomeVC()
        view?.configureHomeTitle()
        view?.configureCollectionView()
    }
    
    func getCoins() {
        service.downloadCoins() { [weak self] returnedCoins in
            guard let self = self else { return }
            guard let returnedCoins = returnedCoins else { return }
            self.coins.append(contentsOf: returnedCoins)
            DispatchQueue.main.async {
                self.view?.reloadCollectionView()
            }
        }
    }
    
    func cycleSortingCriteria() {
        switch sortingCriteria {
        case .rank:
            sortingCriteria = .price
        case .price:
            sortingCriteria = .listedAt
        case .listedAt:
            sortingCriteria = .change
        case .change:
            sortingCriteria = .volume24h
        case .volume24h:
            sortingCriteria = .marketCap
        case .marketCap:
            sortingCriteria = .rank
        }
    }
    
    func sortCoins() {
        switch sortingCriteria {
        case .rank:
            coins.sort { $0.rank ?? 0 < $1.rank ?? 0}
        case .price:
            coins.sort { (coin1, coin2) -> Bool in
                guard let price1 = Double(coin1.price ?? "0"),
                      let price2 = Double(coin2.price ?? "0") else {
                    return false
                }
                return price1 > price2
            }
        case .listedAt:
            coins.sort { $0.listedAt ?? 0 < $1.listedAt ?? 0 }
        case .change:
            coins.sort { (coin1, coin2) -> Bool in
                guard let change1 = Double(coin1.change ?? "0"),
                      let change2 = Double(coin2.change ?? "0") else {
                    return false
                }
                return change1 > change2
            }
        case .volume24h:
            coins.sort { (coin1, coin2) -> Bool in
                guard let volume1 = Double(coin1.volume24h ?? "0"),
                      let volume2 = Double(coin2.volume24h ?? "0") else {
                    return false
                }
                return volume1 > volume2
            }
        case .marketCap:
            coins.sort { (coin1, coin2) -> Bool in
                guard let market1 = Double(coin1.marketCap ?? "0"),
                      let market2 = Double(coin2.marketCap ?? "0") else {
                    return false
                }
                return market1 > market2
            }

        }
    }
}
