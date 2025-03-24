//
//  UnitConverter.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 21.03.25.
//
import Foundation

struct UnitConverter {
    // MARK: - Blutzucker (Blood Glucose)

    private static let mgdLPerMmolL: Double = 18.0182

    static func convertBZ(_ value: Double, from: BloodGlucoseUnit, to: BloodGlucoseUnit) -> Double {
        guard from != to else { return value }
        if from == .mgdL && to == .mmolL {
            return value / mgdLPerMmolL
        } else if from == .mmolL && to == .mgdL {
            return value * mgdLPerMmolL
        }
        return value
    }

    static func toInternalBZ(_ value: Double, from unit: BloodGlucoseUnit) -> Double {
        return convertBZ(value, from: unit, to: .mgdL)
    }

    static func toDisplayBZ(_ value: Double, as unit: BloodGlucoseUnit) -> Double {
        return convertBZ(value, from: .mgdL, to: unit)
    }

    static func fromDisplayBZ(_ value: Double, from unit: BloodGlucoseUnit) -> Double {
        return convertBZ(value, from: unit, to: .mgdL)
    }

    // MARK: - Kohlenhydrate (Carbs)

    enum CarbConversionFactor {
        static let gramsPerKE = 10.0
        static let gramsPerBE = 12.0
    }

    static func convertCarbs(_ value: Double, from: CarbUnit, to: CarbUnit) -> Double {
        guard from != to else { return value }

        // Convert to grams first
        let inGrams: Double = {
            switch from {
                case .grams: return value
                case .carbUnits: return value * CarbConversionFactor.gramsPerKE
                case .breadUnits: return value * CarbConversionFactor.gramsPerBE
            }
        }()

        // Then from grams to target unit
        switch to {
            case .grams: return inGrams
            case .carbUnits: return inGrams / CarbConversionFactor.gramsPerKE
            case .breadUnits: return inGrams / CarbConversionFactor.gramsPerBE
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
