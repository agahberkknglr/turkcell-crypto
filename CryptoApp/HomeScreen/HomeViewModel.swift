//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 5.05.2024.
//

import Foundation

protocol HomeViewModelProtocol {
    var view: HomeScreenViewProtocol? { get set }
    
    func viewDidLoad()
    func getCoins()
    func viewWillAppear()
    
}

final class HomeViewModel {
    weak var view: HomeScreenViewProtocol?
    private let service = CoinService()
    var coins = [Coins]()
}

extension HomeViewModel: HomeViewModelProtocol {
    
    func viewDidLoad() {
        view?.configureCollectionView()
        getCoins()
    }
    
    func viewWillAppear() {
        view?.configureHomeVC()
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
}
