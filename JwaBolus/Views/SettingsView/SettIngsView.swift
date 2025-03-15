import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsStorage: SettingsStorage

    @Environment(\.dismiss) private var dismiss

    @State private var timeSettings: [TimePeriod: TimePeriodConfig] = [:]
    @State private var applyMorningSettings: Bool = false

    let timePeriods: [TimePeriod] = [.morning, .noon, .evening, .night]
    @State private var expandedSections: Set<TimePeriod> = [.morning]

    var body: some View {
        NavigationView {
            Form {
                // Insulin Duration (Global)
                Section(header: Text("Insulin Wirkdauer (Stunden)").font(.headline)) {
                    Stepper(value: $settingsStorage.insulinDuration, in: 1...8, step: 0.5) {
                        Text("\(settingsStorage.insulinDuration, specifier: "%.1f") Stunden")
                    }

                    Button(action: {
                        settingsStorage.resetToDefaults()
                    }, label: {
                        Text("Restinsulin zurücksetzen")
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    })
                    .buttonStyle(BorderedProminentButtonStyle())
                }

                // Apply Morning Settings Button
                Button(action: {
                    applyMorningSettingsToAll()
                }, label: {
                    Text("Einstellungen von Früh für alle Tageszeiten übernehmen")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                })
                .buttonStyle(BorderedProminentButtonStyle())

                // Time Period Sections
                ForEach(timePeriods, id: \.self) { period in
                    Section(header: headerView(for: period)) {
                        if expandedSections.contains(period) {
                            periodSettingsView(for: period)
                        }
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .navigationBarItems(trailing: Button("Fertig") {
                settingsStorage.timePeriodConfigs = timeSettings
                settingsStorage.save()
                dismiss()
            })
            .onAppear {
                timeSettings = settingsStorage.timePeriodConfigs ?? [:]
                expandedSections = [.morning]
            }
            .onDisappear {
                settingsStorage.timePeriodConfigs = timeSettings
                settingsStorage.save()
            }
        }
    }

    private func binding(for period: TimePeriod) -> Binding<TimePeriodConfig> {
        return Binding(
            get: {
                timeSettings[period] ?? TimePeriodConfig(targetBZ: 110, correctionFactor: 20, mealInsulinFactor: 1.0)
            },
            set: { newValue in
                timeSettings[period] = newValue
                if period == .morning {
                    applyMorningSettings = false
                }
            }
        )
    }

    private func applyMorningSettingsToAll() {
        guard let morningSettings = timeSettings[.morning] else { return }
        for period in timePeriods where period != .morning {
            timeSettings[period] = TimePeriodConfig(
                targetBZ: morningSettings.targetBZ,
                correctionFactor: morningSettings.correctionFactor,
                mealInsulinFactor: morningSettings.mealInsulinFactor
            )
        }
    }

    private func periodSettingsView(for period: TimePeriod) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading) {
                Text("Ziel-BZ (mg/dL)")
                TextField("", value: binding(for: period).targetBZ, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
            }

            VStack(alignment: .leading) {
                Text("Korrekturfaktor (mg/dL)")
                TextField("", value: binding(for: period).correctionFactor, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
            }

            VStack(alignment: .leading) {
                Text("Mahlzeiten-Insulin")
                TextField("", value: binding(for: period).mealInsulinFactor,
                          format: .number.precision(.fractionLength(1)))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
            }
        }
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
        .preferredColorScheme(.dark)
}
