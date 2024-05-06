//
//  CoinCell.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 5.05.2024.
//

import UIKit
import SDWebImage

class CoinCell: UICollectionViewCell {
    static let reuseIdentifier = "coinCell"
    
    var iconImageView = UIImageView()
    var coinNameLabel = UILabel()
    var coinSymbolLabel = UILabel()
    //var coinPriceLabel = UILabel()
    //var coinChangeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(coin: Coins){
        coinSymbolLabel.text = coin.symbol
        coinNameLabel.text = coin.name
        if let iconUrl = coin.iconUrl, let url = URL(string: iconUrl) {
            iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    private func setupViews() {
        backgroundColor = UIColor(hex: "#FFFFFF")
        layer.cornerRadius = 16
        addSubview(iconImageView)
        addSubview(coinSymbolLabel)
        addSubview(coinNameLabel)
        //addSubview(coinPriceLabel)
        //addSubview(coinChangeLabel)
        
        configureIconImageView()
        configureLabels()
        setImageConstraints()
        setLabelsContraints()
    }
    
    private func configureIconImageView() {
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true
        
    }
    
    private func configureLabels() {
        coinNameLabel.numberOfLines = 0
        coinNameLabel.textColor = UIColor(hex: "#0C235E")
        coinNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        coinSymbolLabel.numberOfLines = 0
        coinSymbolLabel.textColor = UIColor(hex: "#A9B2C6")
        coinSymbolLabel.font = UIFont.systemFont(ofSize: 13)
        //coinPriceLabel.numberOfLines = 0
        //coinChangeLabel.numberOfLines = 0
        
    }
    
    private func setImageConstraints() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 20),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    private func setLabelsContraints() {
        coinSymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coinSymbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            coinSymbolLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            coinSymbolLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            coinSymbolLabel.bottomAnchor.constraint(equalTo: coinNameLabel.bottomAnchor, constant: -16)
        ])
        coinNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coinNameLabel.topAnchor.constraint(equalTo: coinSymbolLabel.topAnchor, constant: 32),
            coinNameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            coinNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            coinNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
