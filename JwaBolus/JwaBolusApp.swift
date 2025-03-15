//
//  JwaBolusApp.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 26.05.24.
//

import SwiftUI

@main
struct JwaBolusApp: App {
    @StateObject private var settingsStorage = SettingsStorage()
    @StateObject private var viewModel = {
        let storage = SettingsStorage()
        return BolusViewModel(settingsStorage: storage)
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingsStorage)
                .environmentObject(viewModel)
        }
    }
}
