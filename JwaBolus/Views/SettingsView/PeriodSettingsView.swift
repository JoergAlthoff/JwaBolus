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
                title: String(format: NSLocalizedString("target.bg.title", comment: ""),
                              viewModel.bgunit.rawValue),
                text: Binding(
                    get: { viewModel.displayTargetBG(for: period) },
                    set: { viewModel.updateTargetBG(for: period, from: $0) }
                )
            )

            ValidatedNumberField(
                title: String(format: NSLocalizedString("correction.factor.title", comment: ""),
                              viewModel.bgunit.rawValue),
                text: Binding(
                    get: { viewModel.displayCorrectionFactor(for: period) },
                    set: { viewModel.updateCorrectionFactor(for: period, from: $0) }
                )
            )

            ValidatedNumberField(
                title: NSLocalizedString("meal.factor.title", comment: ""),
                text: Binding(
                    get: { viewModel.displayMealFactor(for: period) },
                    set: { viewModel.updateMealFactor(for: period, from: $0) }
                )
            )
        }
        .onAppear {
            print("🟢 Values: BG=\(viewModel.displayTargetBG(for: period))")
        }
    }
}
