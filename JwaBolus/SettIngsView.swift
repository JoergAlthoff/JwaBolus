//
//  SettIngsView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 12.02.25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("mahlzeitenInsulin") private var mahlzeitenInsulin: Double = 3.5
    @AppStorage("korrekturFaktor") private var korrekturFaktor: Int = 20
    @AppStorage("zielBZ") private var zielBZ: Int = 110
    @AppStorage("insulinWirkdauer") private var insulinWirkdauer: Double = 3.5

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bolus-Parameter")) {
                    Stepper(value: $mahlzeitenInsulin, in: 0.1...10.0, step: 0.1) {
                        Text("Mahlzeiten-Insulin: \(String(format: "%.1f", mahlzeitenInsulin)) IE / 10g KH")
                    }
                    
                    Stepper(value: $korrekturFaktor, in: 10...50, step: 5) {
                        Text("Korrektur-Faktor: 1 IE senkt BZ um \(korrekturFaktor) mg/dl")
                    }
                    
                    Stepper(value: $zielBZ, in: 70...150, step: 5) {
                        Text("Ziel-BZ: \(zielBZ) mg/dl")
                    }
                    
                    Stepper(value: $insulinWirkdauer, in: 1.0...8.0, step: 0.5) {
                        Text("Insulin-Wirkdauer: \(String(format: "%.1f", insulinWirkdauer)) Stunden")
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .navigationBarItems(trailing: Button("Fertig") {
                presentationMode.wrappedValue.dismiss() // View schließen
            })
        }
    }
}
