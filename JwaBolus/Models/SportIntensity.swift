//
//  sportIntensity.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 13.03.25.
//
import Foundation

enum SportIntensity: String, CaseIterable {
    case none = "Keiner"
    case light = "Leicht"
    case moderate = "Moderat"
    case intense = "Intensiv"

    var sportFaktor: Double {
        switch self {
        case .light: return 0.75
        case .moderate: return 0.67
        case .intense: return 0.5
        case .none: return 1.0
        }
    }
}
