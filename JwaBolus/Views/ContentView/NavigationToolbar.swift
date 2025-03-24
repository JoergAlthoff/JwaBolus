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
            Button(action: { showHelp.toggle() }) {
                Image(systemName: "info.circle")
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showSettings.toggle() }) {
                Image(systemName: "gearshape.fill")
            }
        }
    }
}
