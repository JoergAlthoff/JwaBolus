//
//  CarbUnit.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 14.03.25.
//
enum CarbUnit: String, CaseIterable {
    case grams = "g"
    case breadUnits = "BU"
    case carbUnits = "CU"

    func toGrams(value: Double) -> Double {
        switch self {
            case .grams: return value
            case .breadUnits: return value * 12.0 // 1 BU = 12g
            case .carbUnits: return value * 10.0 // 1 CU = 10g
        }
    }

    func fromGrams(value: Double) -> Double {
        switch self {
            case .grams: return value
            case .breadUnits: return value / 12.0
            case .carbUnits: return value / 10.0
        }
    }
}
