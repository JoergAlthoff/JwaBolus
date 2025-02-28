//
//  SettingsStorage.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 23.02.25.
//
import Foundation

// Function to save time period settings to UserDefaults
func saveTimeSettings(_ settings: [TimePeriod: TimePeriodConfig]) {
    if let encoded = try? JSONEncoder().encode(settings) {
        UserDefaults.standard.set(encoded, forKey: "TimePeriodSettings")
    }
}

// Function to load time period settings from UserDefaults
func loadTimeSettings() -> [TimePeriod: TimePeriodConfig] {
    if let savedData = UserDefaults.standard.data(forKey: "TimePeriodSettings"),
       let settings = try? JSONDecoder().decode([TimePeriod: TimePeriodConfig].self, from: savedData) {
        return settings
    }
    return defaultValues // Return default values if no saved data exists
}
