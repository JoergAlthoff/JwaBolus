//
//  ContentView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 26.05.24.
//
import SwiftUI

struct ContentView: View {
    @State private var aktuellerBZ: String = ""
    @State private var kohlenhydrate: String = ""
    @State private var berechneteIE: Double?
    @State private var showSettings = false // Steuert, ob SettingsView angezeigt wird
    
    @Environment(\.colorScheme) var colorScheme // Liest den aktuellen Modus (Hell/Dunkel)

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Bolusrechner (mg/dl)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary) // Passt sich automatisch an
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Aktueller BZ in mg/dl")
                        .foregroundColor(Color.primary)
                    TextField("BZ eingeben", text: $aktuellerBZ)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(4)
                        .background(Color(UIColor.systemGray6)) // Automatische Anpassung für Light/Dark Mode
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Kohlenhydrate g")
                        .foregroundColor(Color.primary)
                    TextField("KH eingeben", text: $kohlenhydrate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(4)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Button(action: berechneIE) {
                    Text("Start")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(colorScheme == .dark ? Color.orange : Color.blue) // Unterschiedliche Farben für Dark/Light Mode
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.vertical, 25)
                
                if let ie = berechneteIE {
                    Text("IE: \(String(format: "%.1f", ie))")
                        .font(.title)
                        .foregroundColor(Color.primary)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 2))
                }
                
                Spacer()
            }
            .navigationBarTitle("Bolusrechner")
             .navigationBarItems(trailing:
                 Button(action: { showSettings = true }) {
                     Image(systemName: "gearshape.fill") // Apple-Style Icon für Einstellungen
                         .font(.title)
                 }
             )
             .sheet(isPresented: $showSettings) {
                 SettingsView() // Die View zeigen wir gleich!
             }
            .padding()
            .background(colorScheme == .dark ? Color.black : Color.white) // Hintergrund anpassen
        }
    }
    
    func berechneIE() {
        guard let bz = Int(aktuellerBZ), let kh = Int(kohlenhydrate), bz > 0, kh > 0 else {
            berechneteIE = nil
            return
        }
        
        let ie = Double(kh) / 10.0 + max(0, Double(bz - 100)) / 50.0
        berechneteIE = ie
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
