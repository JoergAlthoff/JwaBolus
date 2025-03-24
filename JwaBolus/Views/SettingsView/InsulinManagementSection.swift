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
        Section(header: Text("Insulin Wirkdauer & Reset").font(.headline)) {
            Stepper(value: $viewModel.insulinDuration, in: 1...8, step: 0.5) {
                Text("\(viewModel.insulinDuration, specifier: "%.1f") Stunden")
            }

            Button(action: {
                viewModel.resetRemainingInsulin()
            }, label: {
                Text("Restinsulin zurücksetzen")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            })
            .buttonStyle(BorderedProminentButtonStyle())
            .padding(.vertical, 4)
        }
    }
}
