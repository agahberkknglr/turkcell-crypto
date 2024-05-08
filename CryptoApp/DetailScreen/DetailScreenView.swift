//
//  DetailScreenView.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 7.05.2024.
//

import UIKit

protocol DetailScreenViewProtocol: AnyObject {
    func configureDetailVC ()
}

class DetailScreenView: UIViewController {
    
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
        view.backgroundColor = .green
        navigationController?.isNavigationBarHidden = false
    }
}
