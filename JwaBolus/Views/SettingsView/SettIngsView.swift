import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsStorage: SettingsStorage
    @Environment(\.dismiss) private var dismiss

    let timePeriods: [TimePeriod] = [.morning, .noon, .evening, .night]
    @State private var expandedSections: Set<TimePeriod> = [.morning]
    @State private var applyMorningSettings: Bool = false

    var body: some View {
        NavigationView {
            Form {
                // Insulin Duration (Global)
                Section(header: Text("Insulin Wirkdauer (Stunden)").font(.headline)) {
                    Stepper(value: $settingsStorage.insulinDuration, in: 1...8, step: 0.5) {
                        Text("\(settingsStorage.insulinDuration, specifier: "%.1f") Stunden")
                    }
                }

                // Blutzucker Einheit Picker
                Section(header: Text("Blutzucker Einheit").font(.headline)) {
                    Picker("Einheit", selection: $settingsStorage.bloodGlucoseUnit) {
                        ForEach(BloodGlucoseUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                // Kohlenhydrate Einheit Picker
                Section(header: Text("Kohlenhydrate Einheit").font(.headline)) {
                    Picker("Einheit", selection: $settingsStorage.carbUnit) {
                        ForEach(CarbUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                // Restinsulin zurücksetzen
                Button(action: {
                    settingsStorage.resetToDefaults()
                }, label: {
                    Text("Einstellungen zurücksetzen")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                })
                .buttonStyle(BorderedProminentButtonStyle())
                .padding()

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
                            PeriodSettingsView(period: period)
                                .environmentObject(settingsStorage)
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
        guard let morningSettings = settingsStorage.timePeriodConfigs[.morning] else {
            print("❌ Fehler: Kein Config für Früh gefunden!")
            return
        }

        print("📌 Werte aus Früh:", morningSettings)

        var updatedConfigs = settingsStorage.timePeriodConfigs
        for period in timePeriods where period != .morning {
            updatedConfigs[period] = TimePeriodConfig(
                targetBZ: morningSettings.targetBZ,
                correctionFactor: morningSettings.correctionFactor,
                mealInsulinFactor: morningSettings.mealInsulinFactor
            )
        }

        settingsStorage.timePeriodConfigs = updatedConfigs
        settingsStorage.saveSettings()

        print("✅ Nach Übernahme:", settingsStorage.timePeriodConfigs)
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
        .environmentObject(SettingsStorage())
        .preferredColorScheme(.dark)
}
