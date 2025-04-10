//
//  sportintensity.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 13.03.25.
//
import Foundation

enum SportIntensity: String, CaseIterable {
    case none = "None"
    case light = "Light"
    case moderate = "Moderate"
    case intense = "Intense"

    var localizedName: String {
        switch self {
        case .none:
            return NSLocalizedString("sportintensity.none", comment: "")
        case .light:
            return NSLocalizedString("sportintensity.light", comment: "")
        case .moderate:
            return NSLocalizedString("sportintensity.moderate", comment: "")
        case .intense:
            return NSLocalizedString("sportintensity.intense", comment: "")
        }
    }

    var sportFaktor: Double {
        switch self {
        case .light:
            0.75
        case .moderate:
            0.67
        case .intense:
            0.5
        case .none:
            1.0
        }
    }
}
