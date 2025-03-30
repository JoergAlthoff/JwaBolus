//
//  CarbUnit.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 14.03.25.
//
import SwiftUI

enum CarbUnit: String, CaseIterable {
    case grams = "g"
    // swiftlint:disable identifier_name
    case bu = "BU"
    case cu = "CU"
    // swiftlint:enable identifier_name

    private static let gramsPerBU: Double = 12.0
    private static let gramsPerCU: Double = 10.0

    var localizedName: String {
        switch self {
        case .grams:
            return NSLocalizedString("carbUnit.grams", comment: "")
        case .bu:
            return NSLocalizedString("carbUnit.bu", comment: "")
        case .cu:
            return NSLocalizedString("carbUnit.cu", comment: "")
        }
    }

    func toGrams(value: Double) -> Double {
        switch self {
        case .grams:
            return value
        case .bu:
            return value * Self.gramsPerBU
        case .cu:
            return value * Self.gramsPerCU
        }
    }

    func fromGrams(value: Double) -> Double {
        switch self {
        case .grams:
            return value
        case .bu:
            return value / Self.gramsPerBU
        case .cu:
            return value / Self.gramsPerCU
        }
    }
}
