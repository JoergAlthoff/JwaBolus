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
            }, label: {
                Image(systemName: SymbolNames.info)
                    .accessibilityLabel("accessibility.info")
                    .accessibilityHint("accessibility.hint.info")
            })
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                showSettings.toggle()
            }, label: {
                Image(systemName: SymbolNames.settings)
                    .accessibilityLabel("accessibility.settings")
                    .accessibilityHint("accessibility.hint.settings")
            })
        }
    }
}
