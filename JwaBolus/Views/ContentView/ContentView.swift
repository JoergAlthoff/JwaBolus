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
                    InputFields()

                    // Start-Button
                    StartButton()

                    // Tageszeiten-Ergebnisse
                    Results()

                    // Restinsulin-Anzeige
                    RemainingInsulin()

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
                    .environmentObject(settingsStorage) // 🔥 SettingsStorage übergeben
            }
            .sheet(isPresented: $showHelp) {
                InfoView()
            }
            .onReceive(timer) { _ in
                viewModel.objectWillChange.send() // 🔍 Überprüfen, ob noch notwendig
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
        .environmentObject(BolusViewModel(settingsStorage: SettingsStorage()))
        .environmentObject(SettingsStorage())
        .preferredColorScheme(.dark)
}
