//
//  RestInsulinView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//
import SwiftUI

struct RestInsulin: View {
    @ObservedObject var viewModel: BolusViewModel

    var body: some View {
        let restInsulin = viewModel.restInsulin()
        let letzteInsulinZeit = viewModel.letzteInsulinZeit

        VStack(spacing: 5) {
            Text("Restinsulin ca. \(restInsulin, specifier: "%.1f") IE\nSeit: \(letzteInsulinZeit, formatter: shortDateFormatter)")
                .multilineTextAlignment(.center)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                )
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
