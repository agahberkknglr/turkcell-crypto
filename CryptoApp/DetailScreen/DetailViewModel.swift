//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 7.05.2024.
//

import Foundation

//MARK: - Protocols
protocol DetailViewModelProtocol {
    var view: DetailScreenViewProtocol? { get set }
    func viewDidLoad()
}

final class DetailViewModel {
    //MARK: - Variables
    weak var view: DetailScreenViewProtocol?
    var coin: Coins?
}

//MARK: - Extension
extension DetailViewModel: DetailViewModelProtocol {
    //MARK: LifeCycles
    func viewDidLoad() {
        view?.setupNavigationBar()
        view?.configureDetailVC()
    }
}
