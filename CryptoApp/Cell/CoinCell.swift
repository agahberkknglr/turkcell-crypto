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
    
    var view = UIView()
    var iconImageView = UIImageView()
    var coinNameLabel = UILabel()
    var coinSymbolLabel = UILabel()
    var coinPriceLabel = UILabel()
    var coinChangeLabel = UILabel()
    var infoStackView = UIStackView()
    var priceStackView = UIStackView()
    var cellStackView = UIStackView()
    
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
        contentView.addSubview(view)
        view.addSubview(iconImageView)
        view.addSubview(cellStackView)
        
        configureIconImageView()
        configureStacks()
        configureLabels()
        setViewConstraints()
        setImageConstraints()
        setStacksConstraints()
    }
    
    private func configureIconImageView() {
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true
        
    }
    
    private func labelConfigurater(label: UILabel, color: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight, textAlignment: NSTextAlignment) {
        label.numberOfLines = 1
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        label.textAlignment = textAlignment
    }
    
    private func configureLabels() {
        labelConfigurater(label: coinNameLabel,
                          color: UIColor(hex: "#0C235E"),
                          fontSize: 17,
                          fontWeight: .semibold,
                          textAlignment: .left)
        
        labelConfigurater(label: coinSymbolLabel,
                          color: UIColor(hex: "#A9B2C6"),
                          fontSize: 13,
                          fontWeight: .light,
                          textAlignment: .left)
        
        labelConfigurater(label: coinPriceLabel,
                          color: UIColor(hex: "#0C235E"),
                          fontSize: 17,
                          fontWeight: .semibold,
                          textAlignment: .right)
        
        labelConfigurater(label: coinChangeLabel,
                          color: .gray,
                          fontSize: 13,
                          fontWeight: .light,
                          textAlignment: .right)
    }
    
    private func configureStacks() {
        infoStackView.axis = .vertical
        infoStackView.spacing = -32
        infoStackView.addArrangedSubview(coinSymbolLabel)
        infoStackView.addArrangedSubview(coinNameLabel)
        infoStackView.distribution = .fillEqually
        
        priceStackView.axis = .vertical
        priceStackView.spacing = -32
        priceStackView.addArrangedSubview(coinPriceLabel)
        priceStackView.addArrangedSubview(coinChangeLabel)
        priceStackView.distribution = .fillEqually
        
        cellStackView.axis = .horizontal
        cellStackView.spacing = 4
        cellStackView.addArrangedSubview(infoStackView)
        cellStackView.addArrangedSubview(priceStackView)
        cellStackView.distribution = .fillEqually
        
    }
    
    private func setViewConstraints() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.pin(view: contentView)
        
    }
    
    private func setImageConstraints() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 20),
            iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
        ])
    }
    
    private func setStacksConstraints() {
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            cellStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            cellStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            cellStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -4)
        ])
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: cellStackView.topAnchor, constant: 4),
            infoStackView.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor, constant: 8),
            infoStackView.trailingAnchor.constraint(equalTo: priceStackView.leadingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor, constant: -8),
        ])
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceStackView.topAnchor.constraint(equalTo: cellStackView.topAnchor, constant: 8),
            priceStackView.leadingAnchor.constraint(equalTo: infoStackView.trailingAnchor, constant: 8),
            priceStackView.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor,constant: -16),
            priceStackView.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor, constant: -8)
        ])
        
    }
}
