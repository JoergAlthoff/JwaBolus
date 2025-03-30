import SwiftUI

struct InputFields: View {
    @EnvironmentObject var viewModel: BolusViewModel
    @Environment(\.scenePhase) private var scenePhase

    @Binding var activeSheet: ActiveSheet?

    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 8) {
                ValidatedNumberField(
                    title: String(
                        format: NSLocalizedString("input.bg.title", comment: ""),
                        viewModel.bgunit.localizedName
                    ),
                    text: Binding(
                        get: { String(viewModel.currentBG) },
                        set: { viewModel.currentBG = Double($0) ?? 0 }
                    )
                )
            }
            .padding(.horizontal)
            .onAppear {
                print("Localized CarbUnit: \(viewModel.carbUnit.localizedName)")
            }

            VStack(alignment: .leading, spacing: 8) {
                ValidatedNumberField(
                    title: String(
                        format: NSLocalizedString("input.carbohydrates.title", comment: ""),
                        viewModel.carbUnit.localizedName
                    ),
                    text: Binding(
                        get: { String(viewModel.carbohydrates) },
                        set: { viewModel.carbohydrates = Double($0) ?? 0 }
                    )
                )
            }
            .padding(.horizontal)
            .onAppear {
                print("Localized BloodGlucoseUnit: \(viewModel.bgunit.localizedName)")
            }

            VStack(alignment: .leading, spacing: 8) {
                SportIntensityMenu(sportintensity: $viewModel.sportintensity)
            }
        }
        .onChange(of: activeSheet) { oldValue, newValue in
            if oldValue != nil, newValue == nil {
                resetValues()
            }
        }
    }

    private func resetValues() {
        viewModel.currentBG = 0
        viewModel.carbohydrates = 0
        viewModel.sportintensity = .none
    }
}

#Preview {
    InputFields(activeSheet: .constant(nil))
        .environmentObject(BolusViewModel())
}
