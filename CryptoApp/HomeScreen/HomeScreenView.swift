//
//  ViewController.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 4.05.2024.
//

import UIKit

protocol HomeScreenViewProtocol: AnyObject {
    
    func configureCollectionView()
    func reloadCollectionView()
}

final class HomeScreenView: UIViewController {
    
    private let viewModel = HomeViewModel()
    
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
    }
}

extension HomeScreenView: HomeScreenViewProtocol {
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout:  createFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CoinCell.self, forCellWithReuseIdentifier: CoinCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        collectionView.pin(view: view)
        collectionView.backgroundColor = UIColor(hex: "#F9F9F9")
    }
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = CGFloat.deviceWidth - 40
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: (itemWidth + 40) / 4)
        layout.minimumLineSpacing = 15
        return layout
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

extension HomeScreenView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.coins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinCell.reuseIdentifier, for: indexPath) as! CoinCell
        cell.setCell(coin: viewModel.coins[indexPath.item])
        return cell
    }
    
    
    
}
