//
//  ResultButton.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 05.03.25.
//
// Zeigt einen einzelnen Button für die Tageszeit an

import SwiftUI

struct ResultButton: View {
    let period:TimePeriod
    let viewModel: BolusViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text(period.rawValue)
                .bold()
            
            Button(action: {
                // Direkter Aufruf der Funktion im ViewModel
                viewModel.speichernInsulingabe(menge: viewModel.ergebnisseProTageszeit[period] ?? 0.0)
            }) {
                Text(String(format: "%.1f", viewModel.ergebnisseProTageszeit[period] ?? 0.0))
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
