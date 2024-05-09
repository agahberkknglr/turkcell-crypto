//
//  UIStackView+Ext.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 9.05.2024.
//

import UIKit

func configureStack(stack: UIStackView, axis: NSLayoutConstraint.Axis, spacing: CGFloat, views: [UIView], distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill) {
    stack.axis = axis
    stack.spacing = spacing
    for view in views {
        stack.addArrangedSubview(view)
    }
    stack.distribution = distribution
    stack.alignment = alignment
}
