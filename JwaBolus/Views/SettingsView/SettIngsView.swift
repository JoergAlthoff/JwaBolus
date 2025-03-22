import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: BolusViewModel
    @Environment(\.dismiss) private var dismiss

    let timePeriods: [TimePeriod] = [.morning, .noon, .evening, .night]
    @State private var expandedSections: Set<TimePeriod> = [.morning]
    @State private var applyMorningSettings: Bool = false

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
            .navigationTitle("Einstellungen")
            .navigationBarItems(trailing: Button("Fertig") {
                dismiss()
            })
        }
    }

    private func applyMorningSettingsToAll() {
        guard let morningSettings = viewModel.timePeriodConfigs[.morning] else {
            print("❌ Fehler: Kein Config für Früh gefunden!")
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

        // 🔥 Speichern der aktualisierten Werte ins ViewModel
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
                Image(systemName: expandedSections.contains(period) ? "chevron.down" : "chevron.right")
                    .foregroundColor(.blue)
            })
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(BolusViewModel())
        .preferredColorScheme(.dark)
}
