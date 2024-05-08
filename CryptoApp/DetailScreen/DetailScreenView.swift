//
//  DetailScreenView.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 7.05.2024.
//

import UIKit

protocol DetailScreenViewProtocol: AnyObject {
    func configureDetailVC()
    func setupNavigationBar()
}

final class DetailScreenView: UIViewController {
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: DetailViewModel
    let coinTitleLabel = UILabel()
    let coinPriceLabel = UILabel()
    let coinChangeLabel = UILabel()
    let coinHighLabel = UILabel()
    let coinLowLabel = UILabel()
    var isHigh = false
    let priceStackView = UIStackView()
    let highLowStackView = UIStackView()
    let infoStackView = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.view = self
        viewModel.viewDidLoad()
    }

}

extension DetailScreenView: DetailScreenViewProtocol {
   
    func configureDetailVC() {
        view.backgroundColor = UIColor(hex: "#F9F9F9")
        navigationController?.isNavigationBarHidden = false
        setupUI()
    }
    
    func setupNavigationBar() {
        setupNavigationTitle()
        setupNavigationBackButton()
    }
    
    private func labelConfigurater(label: UILabel, color: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight, textAlignment: NSTextAlignment, text: String?) {
        label.numberOfLines = 1
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        label.textAlignment = textAlignment
        label.text = text
    }
    
    private func setupNavigationTitle() {
        let containerView = UIView()
        
        let coinSymbolLabel = UILabel()
        labelConfigurater(label: coinSymbolLabel,
                          color: UIColor(hex: "#79808E"),
                          fontSize: 14,
                          fontWeight: .medium,
                          textAlignment: .center,
                          text: viewModel.coin?.symbol)
        
        
        let coinNameLabel = UILabel()
        labelConfigurater(label: coinNameLabel,
                          color: UIColor(hex: "#0C235E"),
                          fontSize: 20,
                          fontWeight: .semibold,
                          textAlignment: .center,
                          text: viewModel.coin?.name)
        
        let stackView = UIStackView(arrangedSubviews: [coinSymbolLabel,coinNameLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        
        containerView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coinSymbolLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            coinNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        navigationItem.titleView = containerView
    }
    
    private func setupNavigationBackButton() {
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor(hex: "#0C235E")
    }
    
    private func setupUI() {
        setLabels()
        setStackViews()
        view.addSubview(coinTitleLabel)
        view.addSubview(infoStackView)
        
        coinTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coinTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            coinTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            coinTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            coinTitleLabel.bottomAnchor.constraint(equalTo: infoStackView.topAnchor, constant: -8)
        ])
        
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: coinTitleLabel.bottomAnchor, constant: 8),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])

    }
    
    private func setLabels() {
        labelConfigurater(label: coinTitleLabel,
                          color: UIColor(hex: "#0C235E"),
                          fontSize: 13,
                          fontWeight: .semibold,
                          textAlignment: .left,
                          text: "CURRENT PRICE")
        if let priceString = viewModel.coin?.price, let price = Double(priceString) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.currencySymbol = "$"
            numberFormatter.maximumFractionDigits = 2
            if let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) {
                labelConfigurater(label: coinPriceLabel,
                                  color: UIColor(hex: "#0C235E"),
                                  fontSize: 27,
                                  fontWeight: .semibold,
                                  textAlignment: .left,
                                  text: formattedPrice)
            }
        }
        if let changeString = viewModel.coin?.change, let change = Double(changeString) {
            isHigh = change < 0 ? false : true
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.currencySymbol = "$"
            numberFormatter.maximumFractionDigits = 2
            if let formattedChange = numberFormatter.string(from: NSNumber(value: change)) {
                if let priceString = viewModel.coin?.price, let price = Double(priceString) {
                    let percentageChange = (change / price) * 100
                    let formattedPercentageChange = String(format: "%.2f%%", percentageChange)
                    labelConfigurater(label: coinChangeLabel,
                                      color: change < 0 ? .systemRed : .systemGreen,
                                      fontSize: 17,
                                      fontWeight: .medium,
                                      textAlignment: .left,
                                      text: "\(formattedPercentageChange) (\(formattedChange))")
                }
            }
            
        }
        if let highString = isHigh ? viewModel.coin?.sparkline?.last : viewModel.coin?.sparkline?.first, let high = Double(highString) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.currencySymbol = ""
            numberFormatter.maximumFractionDigits = 2
            if let formattedHigh = numberFormatter.string(from: NSNumber(value: high)) {
                let attributedString = NSMutableAttributedString(string: "High: ", attributes: [
                        .foregroundColor: UIColor(hex: "#0C235E")
                    ])
                    attributedString.append(NSAttributedString(string: formattedHigh, attributes: [
                        .foregroundColor: UIColor.systemGreen
                    ]))
                labelConfigurater(label: coinHighLabel,
                                  color: .systemGreen,
                                  fontSize: 17,
                                  fontWeight: .medium,
                                  textAlignment: .right,
                                  text: "")
                coinHighLabel.attributedText = attributedString
            }
        }
        if let lowString = isHigh ? viewModel.coin?.sparkline?.first : viewModel.coin?.sparkline?.last, let low = Double(lowString) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.currencySymbol = ""
            numberFormatter.maximumFractionDigits = 2
            if let formattedLow = numberFormatter.string(from: NSNumber(value: low)) {
                let attributedString = NSMutableAttributedString(string: "Low: ", attributes: [
                        .foregroundColor: UIColor(hex: "#0C235E")
                    ])
                    attributedString.append(NSAttributedString(string: formattedLow, attributes: [
                        .foregroundColor: UIColor.systemRed
                    ]))
                labelConfigurater(label: coinLowLabel,
                                  color: .systemRed,
                                  fontSize: 17,
                                  fontWeight: .medium,
                                  textAlignment: .right,
                                  text: "")
                coinLowLabel.attributedText = attributedString
            }
        }
        
        
    }
    
    private func setStackViews() {
        priceStackView.addArrangedSubview(coinPriceLabel)
        priceStackView.addArrangedSubview(coinChangeLabel)
        priceStackView.axis = .vertical
        priceStackView.alignment = .leading
        priceStackView.spacing = 8
        
        highLowStackView.addArrangedSubview(coinHighLabel)
        highLowStackView.addArrangedSubview(coinLowLabel)
        highLowStackView.axis = .vertical
        highLowStackView.alignment = .trailing
        highLowStackView.spacing = 8
        
        infoStackView.addArrangedSubview(priceStackView)
        infoStackView.addArrangedSubview(highLowStackView)
        infoStackView.axis = .horizontal
        highLowStackView.alignment = .trailing
        highLowStackView.spacing = 4
    }
    
}
