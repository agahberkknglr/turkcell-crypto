//
//  UIView+Ext.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 6.05.2024.
//

import UIKit

extension UIView {
    func pin(view: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
