//
//  UnitConverter.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 21.03.25.
//
import Foundation

struct UnitConverter {
    // MARK: - Blutzucker (Blood Glucose)

    static func convertBG(_ value: Double, fromBgu: BloodGlucoseUnit, toBgu: BloodGlucoseUnit) -> Double {
        guard fromBgu != toBgu else { return value }
        if fromBgu == .mgdL && toBgu == .mmolL {
            return value / GlucoseConversion.mmolToMgdl
        } else if fromBgu == .mmolL && toBgu == .mgdL {
            return value * GlucoseConversion.mmolToMgdl
        }
        return value
    }

    static func toInternalBG(_ value: Double, from unit: BloodGlucoseUnit) -> Double {
        return convertBG(value, fromBgu: unit, toBgu: .mgdL)
    }

    static func toDisplayBG(_ value: Double, as unit: BloodGlucoseUnit) -> Double {
        return convertBG(value, fromBgu: .mgdL, toBgu: unit)
    }

    static func fromDisplayBG(_ value: Double, from unit: BloodGlucoseUnit) -> Double {
        return convertBG(value, fromBgu: unit, toBgu: .mgdL)
    }

    // MARK: - Kohlenhydrate (Carbs)

    static func convertCarbs(_ value: Double, fromCU: CarbUnit, toCU: CarbUnit) -> Double {
        guard fromCU != toCU else { return value }

        // Convert to grams first
        let inGrams: Double = {
            switch fromCU {
            case .grams: return value
            case .cu: return value * CarbConversion.gramsPerCU
            case .bu: return value * CarbConversion.gramsPerBU
            }
        }()

        // Then from grams to target unit
        switch toCU {
        case .grams: return inGrams
        case .cu: return inGrams / CarbConversion.gramsPerCU
        case .bu: return inGrams / CarbConversion.gramsPerBU
        }
    }

    static func toInternalCarbs(_ value: Double, from unit: CarbUnit) -> Double {
        return convertCarbs(value, fromCU: unit, toCU: .grams)
    }

    static func toDisplayCarbs(_ value: Double, as unit: CarbUnit) -> Double {
        return convertCarbs(value, fromCU: .grams, toCU: unit)
    }

    static func fromDisplayCarbs(_ value: Double, from unit: CarbUnit) -> Double {
        return convertCarbs(value, fromCU: unit, toCU: .grams)
    }
}
