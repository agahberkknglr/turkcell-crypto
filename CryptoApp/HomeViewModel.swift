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
}

final class HomeViewModel {
    weak var view: HomeScreenViewProtocol?
}

extension HomeViewModel: HomeViewModelProtocol {
    
    func viewDidLoad() {
        view?.configureTableView()
    }
    
    
}
