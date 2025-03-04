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
                    ResultButton(period: period, viewModel: viewModel)
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
