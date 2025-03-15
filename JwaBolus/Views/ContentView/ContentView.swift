//
//  ContentView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: BolusViewModel
    @EnvironmentObject var settingsStorage: SettingsStorage

    @State private var showSettings = false
    @State private var showHelp = false

    // Timer, der alle 5 Minuten feuert
    let timer = Timer.publish(every: 300, on: .main, in: .common).autoconnect()

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Eingabefelder
                    InputFields(viewModel: viewModel)

                    // Start-Button
                    StartButton(viewModel: viewModel)

                    // Tageszeiten-Ergebnisse
                    Results(viewModel: viewModel)

                    // Restinsulin-Anzeige
                    RemainingInsulin(viewModel: viewModel)

                    Spacer()

                    // Versionsanzeige
                    ShowAppVersion()
                }
                .padding(.vertical, 25)
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
            .navigationBarTitle("Bolusrechner")
            .navigationBarItems(
                leading: Button(action: { showHelp.toggle() }, label: { Image(systemName: "info.circle") }),
                trailing: Button(action: { showSettings.toggle() }, label: { Image(systemName: "gearshape.fill") })
            )
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showHelp) {
                InfoView()
            }
            .onReceive(timer) { _ in
                viewModel.objectWillChange.send()
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
