//
//  UnitConverter.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 21.03.25.
//
import Foundation

struct UnitConverter {
    // MARK: - Blutzucker (Blood Glucose)

    static func convertBG(_ value: Double, from: BloodGlucoseUnit, to: BloodGlucoseUnit) -> Double {
        guard from != to else { return value }
        if from == .mgdL && to == .mmolL {
            return value / GlucoseConversion.mmolToMgdl
        } else if from == .mmolL && to == .mgdL {
            return value * GlucoseConversion.mmolToMgdl
        }
        return value
    }

    static func toInternalBG(_ value: Double, from unit: BloodGlucoseUnit) -> Double {
        return convertBG(value, from: unit, to: .mgdL)
    }

    static func toDisplayBG(_ value: Double, as unit: BloodGlucoseUnit) -> Double {
        return convertBG(value, from: .mgdL, to: unit)
    }

    static func fromDisplayBG(_ value: Double, from unit: BloodGlucoseUnit) -> Double {
        return convertBG(value, from: unit, to: .mgdL)
    }

    // MARK: - Kohlenhydrate (Carbs)

    static func convertCarbs(_ value: Double, from: CarbUnit, to: CarbUnit) -> Double {
        guard from != to else { return value }

        // Convert to grams first
        let inGrams: Double = {
            switch from {
                case .grams: return value
                case .cu: return value * CarbConversion.gramsPerCU
                case .bu: return value * CarbConversion.gramsPerBU
            }
        }()

        // Then from grams to target unit
        switch to {
            case .grams: return inGrams
            case .cu: return inGrams / CarbConversion.gramsPerCU
            case .bu: return inGrams / CarbConversion.gramsPerBU
        }
    }

    static func toInternalCarbs(_ value: Double, from unit: CarbUnit) -> Double {
        return convertCarbs(value, from: unit, to: .grams)
    }

    static func toDisplayCarbs(_ value: Double, as unit: CarbUnit) -> Double {
        return convertCarbs(value, from: .grams, to: unit)
    }

    static func fromDisplayCarbs(_ value: Double, from unit: CarbUnit) -> Double {
        return convertCarbs(value, from: unit, to: .grams)
    }
}
