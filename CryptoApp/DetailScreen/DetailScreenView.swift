//
//  DetailScreenView.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 7.05.2024.
//

import UIKit
import SDWebImage

//MARK: - Protocol
protocol DetailScreenViewProtocol: AnyObject {
    func configureDetailVC()
    func setupNavigationBar()
}

final class DetailScreenView: UIViewController {
    
    //MARK: - Initialization
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Variables
    private let viewModel: DetailViewModel
    private let coinTitleLabel = UILabel()
    private let coinPriceLabel = UILabel()
    private let coinChangeLabel = UILabel()
    private let coinHighLabel = UILabel()
    private let coinLowLabel = UILabel()
    private var isHigh = false
    private let priceStackView = UIStackView()
    private let highLowStackView = UIStackView()
    private let infoStackView = UIStackView()
    private let imageStackView = UIStackView()
    private let coinImage = UIImageView()
    private let coinRankLabel = UILabel()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
}

//MARK: - Extensions
extension DetailScreenView: DetailScreenViewProtocol {
   
    //MARK: - Configuration
    func configureDetailVC() {
        view.backgroundColor = UIColor(hex: "#F9F9F9")
        navigationController?.isNavigationBarHidden = false
        setupUI()
    }
    
    //MARK: - Configuration of Navigation Bar
    func setupNavigationBar() {
        setupNavigationTitle()
        setupNavigationBackButton()
    }
    
    private func setupNavigationTitle() {
        let containerView = UIView()
        let coinSymbolLabel = UILabel()
        let coinNameLabel = UILabel()
        let stackView = UIStackView(arrangedSubviews: [coinSymbolLabel,coinNameLabel])
        
        labelConfigurater(label: coinSymbolLabel, color: UIColor(hex: "#79808E"), fontSize: 14, fontWeight: .medium, textAlignment: .center, text: viewModel.coin?.symbol)
        labelConfigurater(label: coinNameLabel, color: UIColor(hex: "#0C235E"), fontSize: 20, fontWeight: .semibold, textAlignment: .center, text: viewModel.coin?.name)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        
        containerView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            coinSymbolLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            coinNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        navigationItem.titleView = containerView
    }
    
    private func setupNavigationBackButton() {
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor(hex: "#0C235E")
    }
    
    //MARK: - Configuration of UI
    private func setupUI() {
        setLabels()
        setStackViews()
        setImage()
        view.addSubview(imageStackView)
        view.addSubview(coinTitleLabel)
        view.addSubview(infoStackView)
        
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 32),
            imageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageStackView.bottomAnchor.constraint(equalTo: coinTitleLabel.topAnchor, constant: -8)
        ])
        
        coinTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coinTitleLabel.topAnchor.constraint(equalTo: imageStackView.bottomAnchor, constant: 32),
            coinTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            coinTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            coinTitleLabel.bottomAnchor.constraint(equalTo: infoStackView.topAnchor, constant: -8)
        ])
        
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: coinTitleLabel.bottomAnchor, constant: 8),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

    }
    
    private func setLabels() {
        labelConfigurater(label: coinTitleLabel, color: UIColor(hex: "#0C235E"), fontSize: 13, fontWeight: .semibold, textAlignment: .left, text: "CURRENT PRICE")
        if let priceString = viewModel.coin?.price, let price = Double(priceString) {
            if let formattedPrice = NumberFormatter.currencyFormatter.string(from: NSNumber(value: price)) {
                labelConfigurater(label: coinPriceLabel, color: UIColor(hex: "#0C235E"), fontSize: 27, fontWeight: .semibold, textAlignment: .left, text: formattedPrice)
            }
        }
        if let changeString = viewModel.coin?.change, let change = Double(changeString) {
            isHigh = change < 0 ? false : true
            if let formattedChange = NumberFormatter.currencyFormatter.string(from: NSNumber(value: change)) {
                if let priceString = viewModel.coin?.price, let price = Double(priceString) {
                    let percentageChange = (change / price) * 100
                    let formattedPercentageChange = String(format: "%.2f%%", percentageChange)
                    labelConfigurater(label: coinChangeLabel, color: change < 0 ? .systemRed : .systemGreen, fontSize: 17, fontWeight: .medium, textAlignment: .left, text: "\(formattedPercentageChange) (\(formattedChange))")
                }
            }
        }
        if let highString = isHigh ? viewModel.coin?.sparkline?.last : viewModel.coin?.sparkline?.first, let high = Double(highString) {
            if let formattedHigh = NumberFormatter.currencyFormatter.string(from: NSNumber(value: high)) {
                let attributedString = NSMutableAttributedString(string: "High: ", attributes: [
                        .foregroundColor: UIColor(hex: "#0C235E")
                    ])
                    attributedString.append(NSAttributedString(string: formattedHigh, attributes: [
                        .foregroundColor: UIColor.systemGreen
                    ]))
                labelConfigurater(label: coinHighLabel, color: .systemGreen, fontSize: 17, fontWeight: .medium, textAlignment: .right)
                coinHighLabel.attributedText = attributedString
            }
        }
        if let lowString = isHigh ? viewModel.coin?.sparkline?.first : viewModel.coin?.sparkline?.last, let low = Double(lowString) {
            if let formattedLow = NumberFormatter.currencyFormatter.string(from: NSNumber(value: low)) {
                let attributedString = NSMutableAttributedString(string: "Low: ", attributes: [
                        .foregroundColor: UIColor(hex: "#0C235E")
                    ])
                    attributedString.append(NSAttributedString(string: formattedLow, attributes: [
                        .foregroundColor: UIColor.systemRed
                    ]))
                labelConfigurater(label: coinLowLabel, color: .systemRed, fontSize: 17, fontWeight: .medium, textAlignment: .right, text: "")
                coinLowLabel.attributedText = attributedString
            }
        }
        labelConfigurater(label: coinRankLabel, color: UIColor(hex: "#0C235E"), fontSize: 22, fontWeight: .semibold, textAlignment: .center,text: "Rank: \(viewModel.coin?.rank ?? 0)")
    }
    
    private func setImage() {
        coinImage.layer.cornerRadius = 8
        coinImage.clipsToBounds = true
        if let iconUrl = viewModel.coin?.iconUrl {
            var modifiedUrl = iconUrl
            if iconUrl.hasSuffix(".svg") {
                modifiedUrl = iconUrl.replacingOccurrences(of: ".svg", with: ".png")
            }
            if let url = URL(string: modifiedUrl) {
                coinImage.sd_setImage(with: url)
            }
        }
        coinImage.contentMode = .scaleAspectFit
        coinImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coinImage.topAnchor.constraint(equalTo: imageStackView.topAnchor, constant: 8),
            coinImage.leadingAnchor.constraint(equalTo: imageStackView.leadingAnchor, constant: 8),
            coinImage.trailingAnchor.constraint(equalTo: imageStackView.trailingAnchor, constant: -8),
            coinImage.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setStackViews() {
        configureStack(stack: priceStackView, axis: .vertical, spacing: 8, views: [coinPriceLabel,coinChangeLabel], alignment: .leading)
        configureStack(stack: highLowStackView, axis: .vertical, spacing: 8, views: [coinHighLabel,coinLowLabel], alignment: .trailing)
        configureStack(stack: infoStackView, axis: .horizontal, spacing: 4, views: [priceStackView,highLowStackView], alignment: .trailing)
        configureStack(stack: imageStackView, axis: .vertical, spacing: 16, views: [coinImage, coinRankLabel], alignment: .center)
    }
}
