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
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                action()
            }, label: {
                Text("applyMorning.button.title")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            })
            .accessibilityLabel("accessibility.applyMorning")
            .accessibilityHint("accessibility.hint.applyMorning")
            .buttonStyle(BorderedProminentButtonStyle())
        }
    }
}
