import SwiftUI

class BolusViewModel: ObservableObject {
    @Published var aktuellerBZ: Int = 110
    @Published var kohlenhydrate: Int = 0
    @Published var gesamtIE: Double? = nil
    @Published var ergebnisseProTageszeit: [TimePeriod: Double] = [:]

    @AppStorage("mahlzeitenInsulin") private var mahlzeitenInsulin: Double = 3.5
    @AppStorage("korrekturFaktor") private var korrekturFaktor: Int = 20
    
    @AppStorage("zielBZ") private var gespeicherterZielBZ: Int = 110
    var zielBZ: Int {
        gespeicherterZielBZ
    }

    @AppStorage("letzeIE") private var letzeIE: Double = 0.0
    
    @AppStorage("letzteInsulinZeit") private var letzteInsulinZeitString: String = ""
    var letzteInsulinZeit: Date {
        get {
            if let gespeicherteZeit = ISO8601DateFormatter().date(from: letzteInsulinZeitString) {
                return gespeicherteZeit
            } else {
                let jetzt = Date()
                letzteInsulinZeitString = ISO8601DateFormatter().string(from: jetzt) // Sofort speichern
                return jetzt
            }
        }
        set {
            letzteInsulinZeitString = ISO8601DateFormatter().string(from: newValue)
        }
    }
    
    func berechneIE() {
        // Tastatur schließen
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
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
        }
        
        ergebnisseProTageszeit = ergebnisse
    }
    
    func minutenSeitLetzterInsulingabe() -> Int {
        let letzteZeit = letzteInsulinZeit // Kein Optional mehr, direkt nutzbar!
        let differenz = Date().timeIntervalSince(letzteZeit)
        return Int(differenz / 60)
    }
    
    func intervalleSeitLetzterInsulingabe() -> Int? {
        let minuten = minutenSeitLetzterInsulingabe()
        return minuten / 30
    }
}
