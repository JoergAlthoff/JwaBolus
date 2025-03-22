//
//  BloodGlucoseUnit.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 14.03.25.
//
enum BloodGlucoseUnit: String, CaseIterable {
    case mgdL = "mg/dL"
    case mmolL = "mmol/L"

    private var conversionFactor: Double { 18.0182 } 

    func toMGDL(value: Double) -> Double {
        return self == .mmolL ? value * conversionFactor : value
    }

    func fromMGDL(value: Double) -> Double {
        return self == .mmolL ? value / conversionFactor : value
    }
}
