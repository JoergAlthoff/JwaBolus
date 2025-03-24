import SwiftUI

struct InputFields: View {
    @EnvironmentObject var viewModel: BolusViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 8) {
                ValidatedNumberField(
                    title: "Aktueller BZ in \(viewModel.bloodGlucoseUnit.rawValue)",
                    text: Binding(
                        get: { String(viewModel.currentBG) },
                        set: { viewModel.currentBG = Double($0) ?? 0 }
                    )
                )
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                ValidatedNumberField(
                    title: "Kohlenhydrate in \(viewModel.carbUnit.rawValue)",
                    text: Binding(
                        get: { String(viewModel.carbohydrates) },
                        set: { viewModel.carbohydrates = Double($0) ?? 0 }
                    )
                )
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Menu("Sport innerhalb von 2 Stunden: \(viewModel.sportIntensity.rawValue)") {
                    ForEach(SportIntensity.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            viewModel.sportIntensity = option
                            KeyboardHelper.hideKeyboard()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(4)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(UIColor.systemGray6), lineWidth: 8))
                .menuStyle(DefaultMenuStyle())
            }
            .padding()
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                resetValues()
            }
        }
    }

    private func resetValues() {
        viewModel.currentBG = 0
        viewModel.carbohydrates = 0
        viewModel.sportIntensity = .none
    }
}

#Preview {
    InputFields()
        .environmentObject(BolusViewModel())
}
