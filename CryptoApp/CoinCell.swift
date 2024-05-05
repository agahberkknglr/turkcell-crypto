//
//  CoinCell.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 5.05.2024.
//

import UIKit

class CoinCell: UICollectionViewCell {
    static let reuseIdentifier = "coinCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        backgroundColor = .systemCyan
        layer.cornerRadius = 16
    }
}
