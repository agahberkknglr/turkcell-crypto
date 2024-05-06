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
    var coinPriceLabel = UILabel()
    var coinChangeLabel = UILabel()
    var infoStackView = UIStackView()
    var priceStackView = UIStackView()
    
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
        if let iconUrl = coin.iconUrl {
            var modifiedUrl = iconUrl
            if iconUrl.hasSuffix(".svg") {
                modifiedUrl = iconUrl.replacingOccurrences(of: ".svg", with: ".png")
            }
            if let url = URL(string: modifiedUrl) {
                iconImageView.sd_setImage(with: url)
            }
        }
        if let priceString = coin.price, let price = Double(priceString) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.currencySymbol = "$"
            numberFormatter.maximumFractionDigits = 2
            if let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) {
                coinPriceLabel.text = formattedPrice
            }
        }
        if let changeString = coin.change, let change = Double(changeString) {
            if change < 0 {
                coinChangeLabel.textColor = .red
            } else {
                coinChangeLabel.textColor = .green
            }
            let formattedChange = String(format: "%.2f", change)
            coinChangeLabel.text = formattedChange
        }
        
        
    }
    
    private func setupViews() {
        backgroundColor = UIColor(hex: "#FFFFFF")
        layer.cornerRadius = 16
        addSubview(iconImageView)
        addSubview(infoStackView)
        addSubview(priceStackView)
        
        configureIconImageView()
        configureStacks()
        configureLabels()
        setImageConstraints()
        setStacksConstraints()
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
        coinPriceLabel.numberOfLines = 0
        coinPriceLabel.textColor = UIColor(hex: "#0C235E")
        coinPriceLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        coinChangeLabel.numberOfLines = 0
        coinChangeLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    private func configureStacks() {
        infoStackView.axis = .vertical
        infoStackView.spacing = 4
        infoStackView.addArrangedSubview(coinSymbolLabel)
        infoStackView.addArrangedSubview(coinNameLabel)
        
        priceStackView.axis = .vertical
        priceStackView.spacing = 4
        priceStackView.addArrangedSubview(coinPriceLabel)
        priceStackView.addArrangedSubview(coinChangeLabel)
        
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
    
    private func setStacksConstraints() {
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            infoStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: priceStackView.leadingAnchor, constant: -20),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
        ])
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            priceStackView.leadingAnchor.constraint(equalTo: infoStackView.trailingAnchor, constant: 16),
            priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

}
