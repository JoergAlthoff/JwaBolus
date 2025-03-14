//
//  BloodGlucoseUnit.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 14.03.25.
//
enum BloodGlucoseUnit: String, CaseIterable {
    case mgdL = "mg/dL"
    case mmolL = "mmol/L"
    
    func toMGDL(value: Double) -> Double {
        return self == .mmolL ? value * 18.0 : value
    }
    
    func fromMGDL(value: Double) -> Double {
        return self == .mmolL ? value / 18.0 : value
    }
}
