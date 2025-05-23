import Combine
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: BolusViewModel

    @AppStorage("hasCompletedInitialSetup") private var hasCompletedInitialSetup: Bool = false

    @State private var activeSheet: ActiveSheet?

    private let refreshInterval: TimeInterval = 60 // seconds
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    let willEnterForeground = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)

    @Environment(\.colorScheme) var colorScheme

    init() {
        Log.debug("ContentView re-rendered", category: .ui)
        timer = Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()
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
                viewModel.updateRemainingInsulin()
            }
            .onReceive(willEnterForeground) { _ in
                viewModel.objectWillChange.send()
                viewModel.updateRemainingInsulin()
            }
            .onAppear {
                if !hasCompletedInitialSetup {
                    activeSheet = .initialSetup
                }
                viewModel.loadTimePeriodConfigs()
                viewModel.loadLastInsulinData()
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
