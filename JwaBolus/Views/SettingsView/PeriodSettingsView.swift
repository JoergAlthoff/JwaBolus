import SwiftUI

struct PeriodSettingsView: View {
    @EnvironmentObject var viewModel: BolusViewModel
    let period: TimePeriod

    init(period: TimePeriod) {
        self.period = period
        print("🧪 PeriodSettingsView loaded for \(period)")
    }

    var body: some View {
        VStack {
            ValidatedNumberField(
                title: String(format: NSLocalizedString("targetBGTitle", comment: ""),
                              viewModel.bloodGlucoseUnit.rawValue),
                text: Binding(
                    get: { viewModel.displayTargetBZ(for: period) },
                    set: { viewModel.updateTargetBZ(for: period, from: $0) }
                )
            )

            ValidatedNumberField(
                title: String(format: NSLocalizedString("correctionFactorTitle", comment: ""),
                              viewModel.bloodGlucoseUnit.rawValue),
                text: Binding(
                    get: { viewModel.displayCorrectionFactor(for: period) },
                    set: { viewModel.updateCorrectionFactor(for: period, from: $0) }
                )
            )

            ValidatedNumberField(
                title: NSLocalizedString("mealFactorTitle", comment: ""),
                text: Binding(
                    get: { viewModel.displayMealFactor(for: period) },
                    set: { viewModel.updateMealFactor(for: period, from: $0) }
                )
            )
        }
        .onAppear {
            print("🟢 Values: BG=\(viewModel.displayTargetBZ(for: period))")
        }
    }
}
