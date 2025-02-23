import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BolusViewModel()
    
    @State private var showSettings = false // Steuert, ob SettingsView angezeigt wird
    
    @Environment(\.colorScheme) var colorScheme // Liest den aktuellen Modus (Hell/Dunkel)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) { // Hält alles zusammen!
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Aktueller BZ in mg/dl")
                        .foregroundColor(Color.primary)
                    TextField(
                        "BZ eingeben",
                        value: $viewModel.aktuellerBZ,
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
                    TextField(
                        "KH eingeben",
                        value: $viewModel.kohlenhydrate,
                        format: .number
                    )
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
                
                // Ergebnisse für die vier Tageszeiten nebeneinander anzeigen
                if !viewModel.ergebnisseProTageszeit.isEmpty {
                    let ergebnisse = viewModel.ergebnisseProTageszeit
                    VStack {
                        Text("Ergebnisse für alle Tageszeiten")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        HStack(spacing: 15) {
                            ForEach(TimePeriod.allCases, id: \ .self) { period in
                                VStack {
                                    Text(period.rawValue)
                                        .font(.subheadline)
                                        .bold()
                                    Text(
                                        String(format: "%.1f", ergebnisse[period] ?? 0.0)
                                    )
                                    .font(.title2)
                                    .foregroundColor(Color.primary)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 2)
                                    )
                                }
                            }
                        }
                    }
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
