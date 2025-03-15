//
//  RemainingInsulin.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//
import SwiftUI

struct RemainingInsulin: View {
    @ObservedObject var viewModel: BolusViewModel
    @EnvironmentObject var settingsStorage: SettingsStorage

    // MARK: - Helper Methods
    private func minutesSinceLastInsulinDose(from timestamp: Date) -> Double {
        let difference = Date().timeIntervalSince(timestamp)
        return difference / 60.0
    }

    var body: some View {
        let elapsedMinutes = minutesSinceLastInsulinDose(from: settingsStorage.lastInsulinTimestamp)

        let labelText = """
            Restinsulin ca. \(String(format: "%.1f", viewModel.remainingInsulin)) IE
            Seit: \(DateFormatter.short.string(from: settingsStorage.lastInsulinTimestamp))
            Vor \(Int(elapsedMinutes)) Minuten verabreicht
            """

        VStack(spacing: 5) {
            Text(labelText)
                .multilineTextAlignment(.center)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                )
        }
        .padding()
    }
}

#Preview {
    let settingsStorage = SettingsStorage()
    let viewModel = BolusViewModel(settingsStorage: settingsStorage)

    return RemainingInsulin(viewModel: viewModel)
        .environmentObject(settingsStorage)
        .preferredColorScheme(.dark)
}
