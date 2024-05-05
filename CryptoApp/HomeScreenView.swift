//
//  ViewController.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 4.05.2024.
//

import UIKit

protocol HomeScreenViewProtocol: AnyObject {
    
    func configureTableView()
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
    func configureTableView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout:  createFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CoinCell.self, forCellWithReuseIdentifier: CoinCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.backgroundColor = .systemOrange
    }
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = CGFloat.deviceWidth - 40
        //let padding: CGFloat = 50
        layout.scrollDirection = .vertical
        //layout.sectionInset = UIEdgeInsets(top: 32, left: padding, bottom: 32, right: padding)
        layout.itemSize = CGSize(width: itemWidth, height: (itemWidth + 40) / 4)
        layout.minimumLineSpacing = 15
        return layout
    }
}

extension HomeScreenView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinCell.reuseIdentifier, for: indexPath)
        return cell
    }
    
    
    
}
