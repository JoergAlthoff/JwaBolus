//
//  KeyboardHelper.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 15.03.25.
//
import Foundation

extension NumberFormatter {
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.alwaysShowsDecimalSeparator = true
        return formatter
    }()
}
