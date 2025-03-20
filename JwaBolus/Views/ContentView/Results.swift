import SwiftUI

struct Results: View {
    @EnvironmentObject var viewModel: BolusViewModel

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Text("Einheiten (IE) nach Tageszeit")
                .font(.headline)

            HStack(spacing: 15) {
                ForEach(TimePeriod.allCases, id: \.self) { period in
                    ResultButton(
                        title: period.rawValue,
                        result: viewModel.resultsPerTimePeriod[period] ?? 0.0,
                        onTap: {
                            viewModel.setInsulinDose(amount: viewModel.resultsPerTimePeriod[period] ?? 0.0)
                            viewModel.updateRemainingInsulin() // ✅ Direkt nach dem Setzen aktualisieren
                        }
                    )
                }
            }

            Text("Die Tasten Früh bis Nacht speichern den Wert für die Restinsulin Berechnung")
                .multilineTextAlignment(.center)
                .font(.footnote)
        }
        .padding(.horizontal)
    }
}

#Preview {
    Results()
        .environmentObject(BolusViewModel(settingsStorage: SettingsStorage()))
        .environmentObject(SettingsStorage())
        .preferredColorScheme(.dark)
}
