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
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        dismiss()
                    }
                    .accessibilityLabel("accessibility.done")
                    .accessibilityHint("accessibility.hint.done")
                }
            }
        }
    }

    private func applyMorningSettingsToAll() {
        guard let morningSettings = viewModel.timePeriodConfigs[.morning] else {
            Log.error("Error: No Config found for morning!", category: .ui)
            return
        }

        var updatedConfigs = viewModel.timePeriodConfigs
        for period in timePeriods where period != .morning {
            updatedConfigs[period] = TimePeriodConfig(
                targetBg: morningSettings.targetBg,
                correctionFactor: morningSettings.correctionFactor,
                mealInsulinFactor: morningSettings.mealInsulinFactor
            )
        }

        // 🔥 Store actualized values to ViewModel
        viewModel.timePeriodConfigs = updatedConfigs
    }

    private func headerView(for period: TimePeriod) -> some View {
        HStack {
            Text(period.localizedValue)
                .font(.headline)
            Spacer()
            Button(
                action: {
                    if expandedSections.contains(period) {
                        expandedSections.remove(period)
                    } else {
                        expandedSections.insert(period)
                    }
                },
                label: {
                    Image(systemName: expandedSections.contains(period)
                        ? SymbolNames.chevronDown : SymbolNames.chevronRight)
                        .foregroundColor(.blue)
                }
            )
            .accessibilityLabel(
                expandedSections.contains(period)
                    ? "accessibility.chevron.collapse"
                    : "accessibility.chevron.expand"
            )
            .accessibilityHint(
                expandedSections.contains(period)
                    ? "accessibility.hint.chevron.collapse"
                    : "accessibility.hint.chevron.expand"
            )
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(BolusViewModel())
        .preferredColorScheme(.dark)
}
