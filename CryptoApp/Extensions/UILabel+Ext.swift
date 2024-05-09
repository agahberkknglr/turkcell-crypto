//
//  UILabel+Ext.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 9.05.2024.
//

import UIKit

func labelConfigurater(label: UILabel, color: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight, textAlignment: NSTextAlignment, text: String? = "") {
    label.numberOfLines = 1
    label.textColor = color
    label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    label.textAlignment = textAlignment
    label.text = text
}
