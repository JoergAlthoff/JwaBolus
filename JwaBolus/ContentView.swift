//
//  ContentView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 26.05.24.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BolusViewModel()
    
    @AppStorage("mahlzeitenInsulin") private var mahlzeitenInsulin: Double = 3.5
    @AppStorage("korrekturFaktor") private var korrekturFaktor: Int = 20
    
    @State private var showSettings = false // Steuert, ob SettingsView angezeigt wird
    
    @Environment(\.colorScheme) var colorScheme // Liest den aktuellen Modus (Hell/Dunkel)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) { // Hält alles zusammen!
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Aktueller BZ in mg/dl")
                        .foregroundColor(Color.primary)
                    TextField("BZ eingeben", value: $viewModel.aktuellerBZ,
                              format: .number
                    )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(4)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Kohlenhydrate g")
                        .foregroundColor(Color.primary)
                    TextField("KH eingeben", value: $viewModel.kohlenhydrate,
                              format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(4)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Button(action: viewModel.berechneIE) {
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
                
                
                if let ie = viewModel.gesamtIE {
                    Text("IE: \(String(format: "%.1f", ie))")
                        .font(.title)
                        .foregroundColor(Color.primary)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 2))
                }
                
                Spacer() // Schiebt die Versionsanzeige nach unten
                
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                   let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                    Text("Version \(version) (Build \(build))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                }
            }
            .padding(.vertical, 50)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .navigationBarTitle("Bolusrechner")
            .navigationBarItems(trailing:
                                    Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
            }
            )
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
        .navigationViewStyle(.stack) // Verhindert extra Seitenansicht auf iPad
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

