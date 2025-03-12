//
//  ResultButton.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 05.03.25.
//
// Zeigt einen einzelnen Button für die Tageszeit an

import SwiftUI

struct ResultButton: View {
    let period: TimePeriod
    @ObservedObject var viewModel: BolusViewModel

    @Environment(\.colorScheme) var colorScheme

    var body: some View {

        let result = viewModel.ergebnisseProTageszeit[period] ?? 0.0

        VStack {
            Text(period.rawValue).bold()

            Button {
                viewModel.setInsulingabe(menge: result)
            } label: {
                Text(String(format: "%.1f", result))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(colorScheme == .dark ? Color.orange : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(PressableButtonStyle())
        }
    }
}

#Preview {
    ResultButton(period: TimePeriod.morning, viewModel: BolusViewModel())
}
