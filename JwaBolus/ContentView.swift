//
//  ContentView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 26.05.24.
//
import SwiftUI

struct ContentView: View {
    
    @AppStorage("mahlzeitenInsulin") private var mahlzeitenInsulin: Double = 3.5
    @AppStorage("korrekturFaktor") private var korrekturFaktor: Int = 20
    @AppStorage("zielBZ") private var zielBZ: Int = 110
    
    @State private var aktuellerBZ: String = ""
    @State private var kohlenhydrate: String = ""
    @State private var berechneteIE: Double?
    @State private var showSettings = false // Steuert, ob SettingsView angezeigt wird
    
    @Environment(\.colorScheme) var colorScheme // Liest den aktuellen Modus (Hell/Dunkel)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Aktueller BZ in mg/dl")
                        .foregroundColor(Color.primary)
                    TextField("BZ eingeben", text: $aktuellerBZ)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(4)
                    // Automatische Anpassung für Light/Dark Mode
                        .background(Color(UIColor.systemGray6))
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
                
                VStack {
                    Spacer() // Schiebt die Versionsanzeige nach unten
                    
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                       let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                        Text("Version \(version) (Build \(build))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.bottom, 10) // Etwas Abstand zum unteren Rand
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom) // Stellt sicher, dass es wirklich unten bleibt
            }
            .navigationBarTitle("Bolusrechner")
            .navigationBarItems(trailing:
                                    Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
            }
            )
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .padding(.vertical, 50)
            .background(colorScheme == .dark ? Color.black : Color.white) // Hintergrund anpassen
        }
    }
    
    func berechneIE() {
        // Tastatur schließen
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        // Eingaben validieren
        guard let bz = Int(aktuellerBZ), let kh = Int(kohlenhydrate), bz > 0 else {
            berechneteIE = nil
            return
        }
        
        // Wenn der aktuelle BZ unter dem Zielwert liegt, kein Insulin nötig
        if bz < zielBZ {
            berechneteIE = 0.0
            return
        }
        
        // Berechnung der Insulinmenge:
        let bolusIE = kh > 0 ? (Double(kh) / 10.0 * mahlzeitenInsulin) : 0.0
        // Nur Korrektur-Insulin falls nötig
        let korrekturIE = max(0, Double(bz - zielBZ)) / Double(korrekturFaktor)
        let gesamtIE = bolusIE + korrekturIE
        
        berechneteIE = gesamtIE
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
