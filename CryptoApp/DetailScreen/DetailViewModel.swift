//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 7.05.2024.
//

import Foundation

protocol DetailViewModelProtocol {
    var view: DetailScreenViewProtocol? { get set }
    func viewDidLoad()
}

final class DetailViewModel {
    weak var view: DetailScreenViewProtocol?
    var coin: Coins?
}

extension DetailViewModel: DetailViewModelProtocol {
    func viewDidLoad() {
        view?.configureDetailVC()
        view?.setupNavigationBar()
    }
}
