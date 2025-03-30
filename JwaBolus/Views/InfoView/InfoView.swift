//
//  InfoView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//
import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            HelpContentView()
                .navigationBarTitle("help.navTitle", displayMode: .inline)
                .navigationBarItems(
                    trailing: Button("done") {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        dismiss()
                    }
                    .accessibilityLabel("accessibility.done")
                )
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
