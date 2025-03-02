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
                
                HStack(spacing: 15) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        VStack {
                            Text(period.rawValue)
                                .bold()
                            
                            Button(action: {
                                speichernAction(period, ergebnisseProTageszeit[period] ?? 0.0)
                            }) {
                                Text(String(format: "%.1f", ergebnisseProTageszeit[period] ?? 0.0))
                                    .frame(maxWidth: .infinity)
                                    .bold()
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
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .preferredColorScheme(.dark) // Vorschau für Dark Mode
            ContentView()
                .preferredColorScheme(.light) // Vorschau für Light Mode
        }
    }

}
