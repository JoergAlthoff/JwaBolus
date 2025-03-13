//
//  sportIntensity.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 13.03.25.
//
import Foundation

enum SportIntensity: String, CaseIterable {
    case keiner = "Keiner"
    case leicht = "Leicht"
    case moderat = "Moderat"
    case intensiv = "Intensiv"

    var sportFaktor: Double {
        switch self {
        case .leicht: return 0.75
        case .moderat: return 0.67
        case .intensiv: return 0.5
        case .keiner: return 1.0
        }
    }
}
