import SwiftUI

class BolusViewModel: ObservableObject {
    // Dynamische Werte, die in der UI beobachtet werden (nicht persistent)
    @Published var aktuellerBZ: Int = 0
    @Published var kohlenhydrate: Int = 0
    @Published var gesamtIE: Double?
    @Published var ergebnisseProTageszeit: [TimePeriod: Double] = [:]

    // Private Backing Properties mit AppStorage für persistente Werte
    @AppStorage("mahlzeitenInsulin") private var storedMahlzeitenInsulin: Double = 3.5
    @AppStorage("korrekturFaktor") private var storedKorrekturFaktor: Int = 20
    @AppStorage("zielBZ") private var storedZielBZ: Int = 110
    @AppStorage("letzteIE") private var storedLetzteIE: Double = 0.0
    @AppStorage("letzteInsulinZeit") private var storedLetzteInsulinZeitString: String = ""
    @AppStorage("insulinDuration") private var storedInsulinDuration: Double = 4.0

    // Computed Properties für persistente Werte (Getter und Setter)

    var mahlzeitenInsulin: Double {
        get { storedMahlzeitenInsulin }
        set { storedMahlzeitenInsulin = newValue }
    }

    var korrekturFaktor: Int {
        get { storedKorrekturFaktor }
        set { storedKorrekturFaktor = newValue }
    }

    var zielBZ: Int {
        get { storedZielBZ }
        set { storedZielBZ = newValue }
    }

    var letzteIE: Double {
        get { storedLetzteIE }
        set { storedLetzteIE = newValue }
    }

    var letzteInsulinZeit: Date {
        get {
            if let date = try? Date(storedLetzteInsulinZeitString, strategy: .iso8601) {
                return date
            } else {
                let now = Date()
                storedLetzteInsulinZeitString = now.formatted(.iso8601)
                return now
            }
        }
        set {
            storedLetzteInsulinZeitString = newValue.formatted(.iso8601)
        }
    }

    var insulinDuration: Double {
        get { storedInsulinDuration }
        set { storedInsulinDuration = newValue }
    }

    // MARK: - Business Logik

    /// Speichert die Insulingabe und aktualisiert den Zeitpunkt.
    func setInsulingabe(menge: Double) {
        self.letzteIE = menge
        self.letzteInsulinZeit = Date()
    }

    // Berechnet das Restinsulin
    var restInsulin: Double {
        let totalDauerMinuten = insulinDuration * 60
        let verstricheneMinuten = minutenSeitLetzterInsulingabe()
        if verstricheneMinuten >= totalDauerMinuten {
            return 0.0
        }
        // Linear abnehmend: Ausgangsmenge * (1 - (verstrichene Minuten / Gesamtdauer))
        return letzteIE * (1 - (verstricheneMinuten / totalDauerMinuten))
    }

    /// Setzt den Restinsulinwert zurück: letzteIE wird auf 0 und die letzte Insulinzeit auf den
    ///  aktuellen Zeitpunkt gesetzt.
    func resetRestInsulin() {
        self.letzteIE = 0.0
        self.letzteInsulinZeit = Date()
    }

    /// Berechnet die verstrichene Zeit seit der letzten Insulingabe in Minuten.
    func minutenSeitLetzterInsulingabe() -> Double {
        let differenz = Date().timeIntervalSince(letzteInsulinZeit)
        return differenz / 60.0
    }

    /// Berechnet den verbleibenden Insulinwert (Restinsulin) anhand der verstrichenen Zeit und der Insulindauer.
    /// Berechnet die Insulinmenge (IE) anhand der aktuellen Werte.
    func berechneIE() {
        // Tastatur schließen
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        var ergebnisse: [TimePeriod: Double] = [:]

        for period in TimePeriod.allCases {
            let zielBZValue = Double(zielBZ)
            let korrekturFaktorValue = Double(korrekturFaktor)
            let mealInsulinFactor = mahlzeitenInsulin
            let aktKh = Double(max(kohlenhydrate, 0))
            let aktBz = Double(max(aktuellerBZ, 0))

            let bolusIE = aktKh > 0 ? (aktKh / 10.0 * mealInsulinFactor) : 0.0
            let korrekturIE = (aktBz - zielBZValue) / korrekturFaktorValue
            ergebnisse[period] = bolusIE + korrekturIE
        }

        ergebnisseProTageszeit = ergebnisse
        print(ergebnisseProTageszeit)
    }
}
