import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: BolusViewModel

    @AppStorage("hasCompletedInitialSetup") private var hasCompletedInitialSetup: Bool = false

    @State private var activeSheet: ActiveSheet?

    let timer = Timer.publish(every: 300, on: .main, in: .common).autoconnect()
    let willEnterForeground = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)

    @Environment(\.colorScheme) var colorScheme

    init() {
        Log.debug("ContentView re-rendered", category: .ui)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                (colorScheme == .dark ? Color.black : Color.white)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        InputFields(activeSheet: $activeSheet)
                        StartButton()
                        Results()
                        RemainingInsulin()
                        Spacer()
                        ShowAppVersion()
                    }
                    .padding(.vertical, 15)
                }
            }
            .navigationTitle("app.title")
            .toolbar {
                NavigationToolbar(
                    showHelp: Binding(
                        get: { activeSheet == .help },
                        set: { if $0 { activeSheet = .help } else { activeSheet = nil } }
                    ),
                    showSettings: Binding(
                        get: { activeSheet == .settings },
                        set: { if $0 { activeSheet = .settings } else { activeSheet = nil } }
                    )
                )
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .settings:
                    SettingsView()
                case .help:
                    InfoView()
                case .initialSetup:
                    InitialSetupView {
                        hasCompletedInitialSetup = true
                        activeSheet = nil
                    }
                }
            }
            .onReceive(timer) { _ in
                viewModel.objectWillChange.send()
            }
            .onReceive(willEnterForeground) { _ in
                viewModel.objectWillChange.send()
            }
            .onAppear {
                if !hasCompletedInitialSetup {
                    activeSheet = .initialSetup
                }
            }
        }
    }
}

// MARK: - Enum for Active Sheet

enum ActiveSheet: Identifiable {
    case settings
    case help
    case initialSetup

    var id: Int { hashValue }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(BolusViewModel())
        .preferredColorScheme(.dark)
}
