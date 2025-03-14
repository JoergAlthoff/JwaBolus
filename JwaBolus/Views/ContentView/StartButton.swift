//
//  StartButtonView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//
import SwiftUI

struct StartButton: View {
    let viewModel: BolusViewModel

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: viewModel.calculateInsulinDose) {
            Text("Start")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(colorScheme == .dark ? Color.orange : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
