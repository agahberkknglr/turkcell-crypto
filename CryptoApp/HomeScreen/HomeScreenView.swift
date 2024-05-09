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
        configureStack(stack: stackView, axis: .horizontal, spacing: 8, views: [homeTitleLabel,homeSortButton], distribution: .fillProportionally)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
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
        homeSortButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        homeSortButton.setTitleColor(UIColor(hex: "#6A61F2"), for: .normal)
        homeSortButton.backgroundColor = UIColor(hex: "#E8E7FF")
        homeSortButton.layer.cornerRadius = 16
        homeSortButton.translatesAutoresizingMaskIntoConstraints = false
        homeSortButton.addTarget(self, action: #selector(sortButtonClicked), for: .touchUpInside)
        homeSortButton.menu = sortButtonMenu()
    }
    
    func sortButtonMenu() -> UIMenu {
        let menuItems = UIMenu(title: "Sort the Crypto Coins", options: .displayInline, children: [
            
            UIAction(title: "Ranking", handler: { [weak self] (_) in
                self?.viewModel.sortingCriteria = .rank
                self?.sortButtonMenuItemClicked()
            }),
            UIAction(title: "Price", handler: { [weak self](_) in
                self?.viewModel.sortingCriteria = .price
                self?.sortButtonMenuItemClicked()
            }),
            UIAction(title: "Listed At", handler: { [weak self] (_) in
                self?.viewModel.sortingCriteria = .listedAt
                self?.sortButtonMenuItemClicked()
            }),
            UIAction(title: "Change", handler: { [weak self](_) in
                self?.viewModel.sortingCriteria = .change
                self?.sortButtonMenuItemClicked()
            }),
            UIAction(title: "24h Volume", handler: { [weak self] (_) in
                self?.viewModel.sortingCriteria = .volume24h
                self?.sortButtonMenuItemClicked()
            }),
            UIAction(title: "MarketCap", handler: { [weak self] (_) in
                self?.viewModel.sortingCriteria = .marketCap
                self?.sortButtonMenuItemClicked()
            }),
        ])
        return menuItems
    }
    
    @objc private func sortButtonMenuItemClicked() {
        updateSortButtonText()
        viewModel.sortCoins()
        reloadCollectionView()
    }
    
    @objc private func sortButtonClicked() {
        viewModel.toggleSortingOrder()
        updateSortButtonText()
        viewModel.sortCoins()
        reloadCollectionView()
    }

    
    private func updateSortButtonText() {
        var sortTitle: String = ""
        var sortSymbol: String = ""
        
        switch viewModel.sortingCriteria {
        case .rank:
            sortTitle = "Ranking"
        case .price:
            sortTitle = "Price"
        case .listedAt:
            sortTitle = "Listed At"
        case .change:
            sortTitle = "Change"
        case .volume24h:
            sortTitle = "24h Vol"
        case .marketCap:
            sortTitle = "Market Cap"
        }
        sortSymbol = viewModel.isAscendingOrder ? "▲" : "▼"
        homeSortButton.setTitle("\(sortTitle) \(sortSymbol)", for: .normal)
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
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
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
