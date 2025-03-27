//
//  NavigationToolbarButtons.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 22.03.25.
//
import SwiftUI

struct NavigationToolbar: ToolbarContent {
    @Binding var showHelp: Bool
    @Binding var showSettings: Bool

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                showHelp.toggle()
            }) {
                Image(systemName: SymbolNames.info)
                    .accessibilityLabel(Text("accessibility.info"))
                    .accessibilityHint(Text("accessibility.hint.info"))
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                showSettings.toggle()
            }) {
                Image(systemName: SymbolNames.settings)
                    .accessibilityLabel(Text("accessibility.settings"))
                    .accessibilityHint(Text("accessibility.hint.settings"))
            }
        }
    }
}
