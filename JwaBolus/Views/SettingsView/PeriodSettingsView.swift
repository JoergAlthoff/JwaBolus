//
//  PeriodSettingsView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 18.03.25.
//
import SwiftUI

struct PeriodSettingsView: View {
    @EnvironmentObject var settingsStorage: SettingsStorage
    let period: TimePeriod

    @State private var targetBZText: String = "0"
    @State private var correctionFactorText: String = "0"
    @State private var mealInsulinFactorText: String = "0"

    private let numberPattern = #"^\d+([.,]\d+)?$"# // Ckecks for Intereger or Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SettingField(title: "Ziel-BZ (mg/dL)", text: $targetBZText, onCommit: {
                    settingsStorage.timePeriodConfigs[period]?.targetBZ = targetBZText
                    settingsStorage.saveSettings()
            })

            SettingField(title: "Korrekturfaktor (mg/dL)", text: $correctionFactorText, onCommit: {
                    settingsStorage.timePeriodConfigs[period]?.correctionFactor = correctionFactorText
                    settingsStorage.saveSettings()
            })

            SettingField(title: "Mahlzeiten-Insulin", text: $mealInsulinFactorText, onCommit: {
                    settingsStorage.timePeriodConfigs[period]?.mealInsulinFactor = mealInsulinFactorText
                settingsStorage.saveSettings()
            })
        }
        .onAppear {
            targetBZText = settingsStorage.timePeriodConfigs[period]?.targetBZ ?? "0"
            correctionFactorText = settingsStorage.timePeriodConfigs[period]?.correctionFactor ?? "0"
            mealInsulinFactorText = settingsStorage.timePeriodConfigs[period]?.mealInsulinFactor ?? "0"
        }
    }
}
