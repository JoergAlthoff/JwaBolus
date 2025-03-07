import SwiftUI

class BolusViewModel: ObservableObject {
    @Published var aktuellerBZ: Int = 0
    @Published var kohlenhydrate: Int = 0
    @Published var gesamtIE: Double? = nil
    @Published var ergebnisseProTageszeit: [TimePeriod: Double] = [:]

    @AppStorage("mahlzeitenInsulin") private var mahlzeitenInsulin: Double = 3.5
    @AppStorage("korrekturFaktor") private var korrekturFaktor: Int = 20
    
    @AppStorage("zielBZ") private var gespeicherterZielBZ: Int = 110
    var zielBZ: Int {
        gespeicherterZielBZ
    }

    @AppStorage("letzteIE") private var letzteIE: Double = 0.0
    
    @AppStorage("letzteInsulinZeit") private var letzteInsulinZeitString: String = ""
    var letzteInsulinZeit: Date {
        get {
            guard let gespeicherteZeit = try? Date(letzteInsulinZeitString, strategy: .iso8601) else {
                // Wird ausgeführt, wenn die Konvertierung fehlschlägt (d.h. nil zurückgibt)
                let now = Date()
                // schreibt die letzteInsukinZeitString als gültiges Datum in den @AppStorage
                letzteInsulinZeitString = now.formatted(.iso8601)
                return now
            }
            return gespeicherteZeit
        }
        set {
            letzteInsulinZeitString = newValue.formatted(.iso8601)
        }
    }
    
    
    func berechneIE() {
        // Tastatur schließen
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        print("Empfangener aktuellerBZ: \(aktuellerBZ)")
        print("Empfangener kohlenhydrate: \(kohlenhydrate)")
        
        
        // Eingaben validieren
        let bz = Double(aktuellerBZ >= 0 ? aktuellerBZ : 0)
        let kh = Double(kohlenhydrate >= 0 ? kohlenhydrate : 0)
        
        var ergebnisse: [TimePeriod: Double] = [:]
        
        for period in TimePeriod.allCases {
            let zielBZ = Double(loadTimeSettings()[period]?.targetBZ ?? 110)
            let korrekturFaktor = Double(loadTimeSettings()[period]?.correctionFactor ?? 20)
            let mahlzeitenInsulin = loadTimeSettings()[period]?.mealInsulinFactor ?? 1.0
            
            let bolusIE = kh > 0 ? (kh / 10.0 * mahlzeitenInsulin) : 0.0
            let korrekturIE = (bz - zielBZ) / korrekturFaktor
            ergebnisse[period] = bolusIE + korrekturIE
            
            print("zielBz: \(zielBZ), korrekturFaktor: \(korrekturFaktor), mahlzeitenInsulin: \(mahlzeitenInsulin), bolusIE: \(bolusIE), korrekturIE: \(korrekturIE), ergebnis: \(ergebnisse[period] ?? 0)")
        }
        
        ergebnisseProTageszeit = ergebnisse
        print(ergebnisseProTageszeit)
    }

    var insulinDuration: Double {
        UserDefaults.standard.double(forKey: "InsulinDuration")
    }
    
    func speichernInsulingabe(menge: Double) {
        print("Empfangene Insulingabe: \(menge)")
        letzteIE = menge
        letzteInsulinZeit = Date()
    }
    
    func minutenSeitLetzterInsulingabe() -> Double {
        let differenz = Date().timeIntervalSince(letzteInsulinZeit)
        return Double(differenz / 60)
    }
    
    func restInsulin() -> Double {
        let totalDauerMinuten = insulinDuration * 60
        let verstricheneMinuten = minutenSeitLetzterInsulingabe()
        if verstricheneMinuten >= totalDauerMinuten {
            return 0.0
        }
            // Linear abnehmend: Ausgangsmenge * (1 - (verstrichene Minuten / Gesamtdauer))
        return letzteIE * (1 - (Double(verstricheneMinuten) / totalDauerMinuten))
    }}
