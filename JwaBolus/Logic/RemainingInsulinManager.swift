//
//  RemainingInsulinManager.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 14.03.25.
//
import Foundation

class RemainingInsulinManager {
    static func calculateRemainingInsulin(lastDose: Double, lastTimestamp: Date, durationHours: Double) -> Double {
        let totalDurationMinutes = durationHours * 60
        let elapsedMinutes = Date().timeIntervalSince(lastTimestamp) / 60.0

        if elapsedMinutes >= totalDurationMinutes {
            return 0.0
        }
        return lastDose * (1 - (elapsedMinutes / totalDurationMinutes))
    }
}
