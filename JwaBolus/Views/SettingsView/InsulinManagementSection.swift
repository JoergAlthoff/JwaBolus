//
//  InsulinManagementSection.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 22.03.25.
//
import SwiftUI

struct InsulinManagementSection: View {
    @EnvironmentObject var viewModel: BolusViewModel

    var body: some View {
        Section(header: Text("insulin.section.title").font(.headline)) {
            Stepper(value: $viewModel.insulinDuration, in: 1 ... 8, step: 0.5) {
                Text(String(format: NSLocalizedString("insulin.duration.label", comment: ""), viewModel.insulinDuration))
            }

            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                viewModel.resetRemainingInsulin()
            }, label: {
                Text("resetInsulin.button.title")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            })
            .accessibilityLabel("accessibility.resetInsulin")
            .accessibilityHint("accessibility.hint.resetInsulin")
            .buttonStyle(BorderedProminentButtonStyle())
            .padding(.vertical, 4)
        }
    }
}
