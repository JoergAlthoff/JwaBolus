//
//  TageszeitenView.swift
//  JwaBolus
//
import SwiftUI

struct Results: View {
    @ObservedObject var viewModel: BolusViewModel

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Text("Einheiten (IE) nach Tageszeit")
                .font(.headline)

            HStack(spacing: 15) {
                ForEach(TimePeriod.allCases, id: \.self) { period in
                    ResultButton(period: period, viewModel: viewModel)
                }
            }

            Text("Die Tasten Früh bis Nacht speichern den Wert für die Restinulin Berechnung")
                .multilineTextAlignment(.center)
                .font(.footnote)
        }
        .padding(.horizontal)
    }
}

#Preview {
    let settingsStorage = SettingsStorage()
    let viewModel = BolusViewModel(settingsStorage: settingsStorage)

    return Results(viewModel: viewModel)
        .environmentObject(settingsStorage)
        .preferredColorScheme(.dark)
}
