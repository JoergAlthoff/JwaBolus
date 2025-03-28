//
//  InitialSetupView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 26.03.25.
//
import SwiftUI

struct InitialSetupView: View {
    var onFinish: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                MarkdownText("initial.setup.title")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top)

                Text("initial.setup.message")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)

                Spacer()

                NavigationLink("initial.setup.goToSettings") {
                    SettingsView()
                }
                .buttonStyle(.borderedProminent)
                .padding()

                Text("initial.setup.disclaimer")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                Button("initial.setup.done") {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    onFinish()
                }
                .accessibilityLabel(Text("accessibility.initial.setup.done"))
                .accessibilityHint(Text("accessibility.hint.initialSetup.done"))
                .padding(.bottom)
            }
            .padding()
            .navigationTitle("initial.setup.navigationTitle")
        }
    }
}
