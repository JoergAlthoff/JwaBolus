//
//  TageszeitenView.swift
//  JwaBolus
//
import SwiftUI

struct Tageszeiten: View {
    @ObservedObject var viewModel: BolusViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("Ergebnisse nach Tageszeiten")
                .font(.headline)
            
            HStack(spacing: 15) {
                ForEach(TimePeriod.allCases, id: \.self) { period in
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
        }
        .padding(.horizontal)
    }
}

#Preview {
    // Hier wird das ViewModel explizit übergeben
    Tageszeiten(viewModel: BolusViewModel())
        .preferredColorScheme(.dark)
}
