//
//  ContentView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BolusViewModel()
    
    @State private var showSettings = false
    @State private var showHelp = false
    
    // Timer, der alle 5 Minuten feuert
    let timer = Timer.publish(every: 300, on: .main, in: .common).autoconnect()
    
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Eingabefelder
                InputFieldsView(aktuellerBZ: $viewModel.aktuellerBZ, kohlenhydrate: $viewModel.kohlenhydrate)
                
                // Start-Button
                StartButtonView(action: viewModel.berechneIE)
                
                // Restinsulin-Anzeige
                RestInsulinView(restInsulin: viewModel.restInsulin(),
                                letzteInsulinZeit: viewModel.letzteInsulinZeit,
                                dateFormatter: shortDateFormatter)
                
                // Tageszeiten-Ergebnisse
                TageszeitenView(ergebnisseProTageszeit: viewModel.ergebnisseProTageszeit, speichernAction: { period, menge in
                    viewModel.speichernInsulingabe(menge: menge)
                })
                
                Spacer()
                
                // Versionsanzeige
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                   let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                    Text("Version \(version) (Build \(build))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                }
            }
            .padding(.vertical, 25)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .navigationBarTitle("Bolusrechner")
            .navigationBarItems(
                leading: Button(action: { showHelp = true }) {
                    Image(systemName: "info.circle")
                },
                trailing: Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                }
            )
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showHelp) {
                InfoView()
            }
            .onReceive(timer) { _ in
                viewModel.objectWillChange.send()
            }
        }
        .navigationViewStyle(.stack)
 
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
