//
//  NumberFormatter+Ext.swift
//  CryptoApp
//
//  Created by Agah Berkin Güler on 9.05.2024.
//

import Foundation

extension NumberFormatter {
    static var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        return formatter
    }
}
