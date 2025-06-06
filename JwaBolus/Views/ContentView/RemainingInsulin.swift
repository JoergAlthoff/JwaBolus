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
        if viewModel.remainingInsulin > 0.0 {
            let labelText = """
            \(String(format: NSLocalizedString("remaining.insulin.iu", comment: ""), viewModel.remainingInsulin))
            \(String(format: NSLocalizedString("saved.insulin.time", comment: ""), elapsedTime))
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
            .onChange(of: viewModel.remainingInsulin) { _, _ in
                updateElapsedTime()
            }
            .onAppear {
                updateElapsedTime()
            }
        }
    }
}

#Preview {
    RemainingInsulin()
        .environmentObject(BolusViewModel())
        .preferredColorScheme(.dark)
}
