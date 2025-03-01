//
//  StartButtonView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//
import SwiftUI

struct StartButtonView: View {
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            Text("Start")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(colorScheme == .dark ? Color.orange : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.vertical, 25)
    }
}
