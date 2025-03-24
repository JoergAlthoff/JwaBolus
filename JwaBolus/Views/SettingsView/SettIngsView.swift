import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: BolusViewModel
    @Environment(\.dismiss) private var dismiss

    let timePeriods: [TimePeriod] = [.morning, .noon, .evening, .night]
    @State private(set) var expandedSections: Set<TimePeriod> = [.morning]

    var body: some View {
        NavigationView {
            Form {
                InsulinManagementSection()
                BloodGlucoseUnitSection()
                CarbUnitSection()
                ApplyMorningButton(action: applyMorningSettingsToAll)

                // Time Period Sections
                ForEach(timePeriods, id: \.self) { period in
                    Section(header: headerView(for: period)) {
                        if expandedSections.contains(period) {
                            PeriodSettingsView(period: period)
                                .environmentObject(viewModel)
                        }
                    }
                }
            }
            .navigationTitle("settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func applyMorningSettingsToAll() {
        guard let morningSettings = viewModel.timePeriodConfigs[.morning] else {
            print(Constants.noMorningConfigError)
            return
        }

        var updatedConfigs = viewModel.timePeriodConfigs
        for period in timePeriods where period != .morning {
            updatedConfigs[period] = TimePeriodConfig(
                targetBZ: morningSettings.targetBZ,
                correctionFactor: morningSettings.correctionFactor,
                mealInsulinFactor: morningSettings.mealInsulinFactor
            )
        }

        // 🔥 Store actualized values to ViewModel
        viewModel.timePeriodConfigs = updatedConfigs
    }

    private func headerView(for period: TimePeriod) -> some View {
        HStack {
            Text(period.rawValue)
                .font(.headline)
            Spacer()
            Button(action: {
                if expandedSections.contains(period) {
                    expandedSections.remove(period)
                } else {
                    expandedSections.insert(period)
                }
            }, label: {
                Image(systemName: expandedSections.contains(period) ? Symbols.chevronDown : Symbols.chevronRight)
                    .foregroundColor(.blue)
            })
        }
    }

    private enum Constants {
        static let noMorningConfigError = "❌ Error: No Config found for morning!"
    }

    private enum Symbols {
        static let chevronDown = "chevron.down"
        static let chevronRight = "chevron.right"
    }
}

#Preview {
    SettingsView()
        .environmentObject(BolusViewModel())
        .preferredColorScheme(.dark)
}
