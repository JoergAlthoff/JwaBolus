import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: BolusViewModel

    @State private var showSettings = false
    @State private var showHelp = false

    // Timer, every 5 Minuts to refresh view
    let timer = Timer.publish(every: 300, on: .main, in: .common).autoconnect()

    // App comes to foreground
    let willEnterForeground: NotificationCenter.Publisher =
            NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)

    @Environment(\.colorScheme) var colorScheme

    init() {
        print("🔄 ContentView re-rendered")
    }

    var body: some View {
        NavigationStack {
            ZStack {
                (colorScheme == .dark ? Color.black : Color.white)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        InputFields()
                        StartButton()
                        Results()
                        RemainingInsulin()
                        Spacer()
                        ShowAppVersion()
                    }
                    .padding(.vertical, 15)
                }
            }
            .navigationTitle("Bolusrechner")
            .toolbar {
                NavigationToolbar(showHelp: $showHelp, showSettings: $showSettings)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showHelp) {
                InfoView()
            }
            .onReceive(timer) { _ in
                viewModel.objectWillChange.send()
            }
            .onReceive(willEnterForeground) { _ in
                viewModel.objectWillChange.send()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BolusViewModel())
        .preferredColorScheme(.dark)
}
