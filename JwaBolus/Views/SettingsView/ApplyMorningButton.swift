//
//  ApplyMorningButton.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 22.03.25.
//
import SwiftUI

struct ApplyMorningButton: View {
    let action: () -> Void

    var body: some View {
        Section {
            Button(action: {
                action()
            }, label: {
                Text("Einstellungen von Früh für alle Tageszeiten übernehmen")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            })
            .buttonStyle(BorderedProminentButtonStyle())
        }
    }
}
