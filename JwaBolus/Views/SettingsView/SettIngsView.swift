import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var timeSettings = loadTimeSettings()
    @State private var insulinDuration: Double = UserDefaults.standard.double(forKey: "InsulinDuration")
    @State private var applyMorningSettings: Bool = false
    
    let timePeriods: [TimePeriod] = [.morning, .noon, .evening, .night]
    @State private var expandedSections: Set<TimePeriod> = [.morning]
    
    var body: some View {
        NavigationView {
            Form {
                    // Apply Morning Settings Toggle
                Section {
                    Toggle("Einstellungen von Früh für alle Tageszeiten übernehmen", isOn: $applyMorningSettings)
                        .onChange(of: applyMorningSettings) {
                            applyMorningSettingsToAll()
                        }
                }
                
                
                    // Time Period Sections
                ForEach(timePeriods, id: \ .self) { period in
                    Section(header: HStack {
                        Text(period.rawValue).font(.headline)
                        Spacer()
                        Button(action: {
                            if expandedSections.contains(period) {
                                expandedSections.remove(period)
                            } else {
                                expandedSections.insert(period)
                            }
                        }) {
                            Image(systemName: expandedSections.contains(period) ? "chevron.down" : "chevron.right")
                                .foregroundColor(.blue)
                        }
                    }) {
                        if expandedSections.contains(period) {
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
                                TextField("", value: binding(for: period).mealInsulinFactor, format: .number.precision(.fractionLength(1)))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                            }
                        }
                    }
                }
                
                // Insulin Duration (Global)
                Section(header: Text("Wirkdauer (Stunden)").font(.headline)) {
                    Stepper(value: $insulinDuration, in: 1...8, step: 0.5) {
                        Text("\(insulinDuration, specifier: "%.1f") Stunden")
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .navigationBarItems(trailing: Button("Fertig") {
                saveTimeSettings(timeSettings)
                UserDefaults.standard.set(insulinDuration, forKey: "InsulinDuration")
                dismiss()
            })
            .onAppear {
                if insulinDuration == 0 { // Set default value if not set
                    insulinDuration = 4.0
                }
                expandedSections = [.morning] // Start with only morning expanded
            }
            .onDisappear {
                saveTimeSettings(timeSettings)
                UserDefaults.standard.set(insulinDuration, forKey: "InsulinDuration")
            }
        }
    }
    
    private func binding(for period: TimePeriod) -> Binding<TimePeriodConfig> {
        return Binding(
            get: { timeSettings[period] ?? TimePeriodConfig(targetBZ: 110, correctionFactor: 20, mealInsulinFactor: 1.0) },
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
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
