//
//  TageszeitenView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//
import SwiftUI

struct TageszeitenView: View {
    let ergebnisseProTageszeit: [TimePeriod: Double]
    let speichernAction: (TimePeriod, Double) -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if !ergebnisseProTageszeit.isEmpty {
            VStack {
                Text("Ergebnisse nach Tageszeiten")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                HStack(spacing: 15) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        VStack {
                            Text(period.rawValue)
                                .font(.subheadline)
                                .bold()
                            
                            Button(action: {
                                speichernAction(period, ergebnisseProTageszeit[period] ?? 0.0)
                            }) {
                                Text(String(format: "%.1f", ergebnisseProTageszeit[period] ?? 0.0))
                                    .font(.title)
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
}
