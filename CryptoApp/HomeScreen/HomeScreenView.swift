//
//  ViewController.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 4.05.2024.
//

import UIKit

//MARK: - Protocols
protocol HomeScreenViewProtocol: AnyObject {
    func configureHomeVC()
    func configureHomeTitle()
    func configureCollectionView()
    func reloadCollectionView()
    func navigateToDetailScreen(with coin: Coins)
}

final class HomeScreenView: UIViewController {
    
    //MARK: - Variables
    private let viewModel = HomeViewModel()
    private var collectionView: UICollectionView!
    private var stackView = UIStackView()
    private var homeTitleLabel = UILabel()
    private var homeSortButton = UIButton()

    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}

//MARK: - Extensions
extension HomeScreenView: HomeScreenViewProtocol {
    
    //MARK: - Configuration
    func configureHomeVC() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor(hex: "#F9F9F9")
    }
    
    //MARK: - Configuration Title
    func configureHomeTitle() {
        setTitleLabel()
        setSortButton()
        stackView.addArrangedSubview(homeTitleLabel)
        stackView.addArrangedSubview(homeSortButton)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            homeSortButton.leadingAnchor.constraint(equalTo: homeTitleLabel.trailingAnchor, constant: 16),
            homeSortButton.centerYAnchor.constraint(equalTo: homeTitleLabel.centerYAnchor),
            homeSortButton.widthAnchor.constraint(equalToConstant: 130)
            
        ])
    }
    
    private func setTitleLabel() {
        homeTitleLabel.text = "Ranking List"
        homeTitleLabel.textColor = UIColor(hex: "#0C235E")
        homeTitleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        homeTitleLabel.textAlignment = .left
        homeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setSortButton() {
        updateSortButtonText()
        homeSortButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        homeSortButton.setTitleColor(UIColor(hex: "#6A61F2"), for: .normal)
        homeSortButton.backgroundColor = UIColor(hex: "#E8E7FF")
        homeSortButton.layer.cornerRadius = 16
        homeSortButton.translatesAutoresizingMaskIntoConstraints = false
        
        homeSortButton.addTarget(self, action: #selector(sortButtonClicked), for: .touchUpInside)
        
    }
    
    @objc private func sortButtonClicked() {
        viewModel.cycleSortingCriteria()
        updateSortButtonText()
        viewModel.sortCoins()
        reloadCollectionView()
    }
    
    private func updateSortButtonText() {
        switch viewModel.sortingCriteria {
        case .rank:
            homeSortButton.setTitle("Ranking ▼", for: .normal)
        case .price:
            homeSortButton.setTitle("Price ▲", for: .normal)
        case .listedAt:
            homeSortButton.setTitle("Listed At ▲", for: .normal)
        case .change:
            homeSortButton.setTitle("Change ▲", for: .normal)
        case .volume24h:
            homeSortButton.setTitle("24h Volume ▲", for: .normal)
        case .marketCap:
            homeSortButton.setTitle("Market Cap ▲", for: .normal)
        }
    }
    
    //MARK: - Configuration of Collection View
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout:  createFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CoinCell.self, forCellWithReuseIdentifier: CoinCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(hex: "#F9F9F9")
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    func navigateToDetailScreen(with coin: Coins) {
        let detailViewModel = DetailViewModel()
        detailViewModel.coin = coin
        let detailViewController = DetailScreenView(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: - Extension of CollectionView
extension HomeScreenView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.coins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinCell.reuseIdentifier, for: indexPath) as! CoinCell
        cell.setCell(coin: viewModel.coins[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCoin = viewModel.coins[indexPath.item]
        navigateToDetailScreen(with: selectedCoin)
    }
}
