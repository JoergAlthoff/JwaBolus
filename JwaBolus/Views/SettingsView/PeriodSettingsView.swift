import SwiftUI

struct PeriodSettingsView: View {
    @EnvironmentObject var viewModel: BolusViewModel
    let period: TimePeriod

    var body: some View {
        Form {
            SettingField(
                title: "Ziel-BZ (\(viewModel.bloodGlucoseUnit.rawValue))",
                text: Binding(
                    get: { viewModel.displayTargetBZ(for: period) },
                    set: { viewModel.updateTargetBZ(for: period, from: $0) }
                )
            )

            SettingField(
                title: "Korrekturfaktor (\(viewModel.bloodGlucoseUnit.rawValue))",
                text: Binding(
                    get: { viewModel.displayCorrectionFactor(for: period) },
                    set: { viewModel.updateCorrectionFactor(for: period, from: $0) }
                )
            )

            SettingField(
                title: "Mahlzeiten-Insulin",
                text: Binding(
                    get: { viewModel.displayMealFactor(for: period) },
                    set: { viewModel.updateMealFactor(for: period, from: $0) }
                )
            )
        }
    }
}
