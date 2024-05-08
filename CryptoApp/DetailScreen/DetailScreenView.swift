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

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.view = self
        viewModel.viewDidLoad()
    }

}

extension DetailScreenView: DetailScreenViewProtocol {
   
    func configureDetailVC() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
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
                          fontSize: 17,
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
    
}
