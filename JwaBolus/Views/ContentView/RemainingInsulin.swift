//
//  RemainingInsulin.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//
import SwiftUI

struct RemainingInsulin: View {
    @EnvironmentObject var viewModel: BolusViewModel

    @State private var elapsedTime: String = ""

    // MARK: - Helper Methods
    private func updateElapsedTime() {
        elapsedTime = viewModel.timeSinceLastDose()
    }

    var body: some View {
        let labelText = """
            Restinsulin ca. \(String(format: "%.1f", viewModel.remainingInsulin)) IE
            Gespeichert vor \(elapsedTime) Stunden
            """

        VStack(spacing: 5) {
            Text(labelText)
                .multilineTextAlignment(.center)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                )
        }
        .padding()
        .onAppear {
            updateElapsedTime() // Erste Aktualisierung direkt bei Anzeige
            Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
                updateElapsedTime()
            }
        }
    }
}

#Preview {
    return RemainingInsulin()
        .environmentObject(BolusViewModel())
        .preferredColorScheme(.dark)
}
