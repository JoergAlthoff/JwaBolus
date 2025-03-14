//
//  RestInsulinView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//
import SwiftUI

struct RemainingInsulin: View {
    @ObservedObject var viewModel: BolusViewModel

    var body: some View {
        let labelText = """
            Restinsulin ca. \(String(format: "%.1f", viewModel.remainingInsulin)) IE
            Seit: \(DateFormatter.short.string(from: viewModel.lastInsulinTimestamp))
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

    }
}

#Preview {
    RemainingInsulin(viewModel: BolusViewModel())
        .preferredColorScheme(.dark)
}
