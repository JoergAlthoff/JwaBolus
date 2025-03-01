//
//  RestInsulinView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//
import SwiftUI

struct RestInsulinView: View {
    let restInsulin: Double
    let letzteInsulinZeit: Date
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack(spacing: 5) {
            Text("Restinsulin ca. \(restInsulin, specifier: "%.1f") IE\nSeit: \(letzteInsulinZeit, formatter: dateFormatter)")
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
