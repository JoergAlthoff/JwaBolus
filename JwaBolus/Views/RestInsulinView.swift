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
        VStack(spacing: 20) {
            Text("Vorhandenes Restinsulin: ca. \(restInsulin, specifier: "%.1f") IE\nLetzte Speicherung: \(letzteInsulinZeit, formatter: dateFormatter)")
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                )
        }
        .padding()
    }
}
