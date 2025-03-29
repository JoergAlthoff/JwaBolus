//
//  BloodGlucoseUnit.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 14.03.25.
//
import Foundation

enum BloodGlucoseUnit: String, CaseIterable, Identifiable {
    case mgdL = "mg/dL"
    case mmolL = "mmol/L"

    var id: String { rawValue }

    var localizedName: String {
        switch self {
        case .mgdL:
            NSLocalizedString("bgunit.mgdl", comment: "")
        case .mmolL:
            NSLocalizedString("bgunit.mmol", comment: "")
        }
    }

    func toMGDL(value: Double) -> Double {
        self == .mmolL ? value * GlucoseConversion.mmolToMgdl : value
    }

    func fromMGDL(value: Double) -> Double {
        self == .mmolL ? value / GlucoseConversion.mmolToMgdl : value
    }
}
