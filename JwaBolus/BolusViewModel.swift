//
//  BolusViewModel.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 14.02.25.
//
import SwiftUI

class BolusViewModel: ObservableObject {
    @Published var aktuellerBZ: String = ""
    @Published var kohlenhydrate: String = ""
    @Published var berechneteIE: Double?
    
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
        guard let bz = Int(aktuellerBZ), let kh = Int(kohlenhydrate), bz >= 0 else {
            berechneteIE = nil
            return
        }
        
        // Berechnung der Mahlzeiten-Insulinmenge
        let bolusIE = kh > 0 ? (Double(kh) / 10.0 * mahlzeitenInsulin) : 0.0
        
        // Berechnung der Korrektur-Insulinmenge
        let korrekturIE = Double(bz - zielBZ) / Double(korrekturFaktor) // Kann jetzt auch negativ sein
        
        // Neue Logik: Wenn der BZ zu niedrig ist, prüfen, ob die KH ausreichen
        if bz < zielBZ {
            let fehlendesBZ = Double(zielBZ - bz) // Wie viel BZ fehlt
            let kompensationsKH = fehlendesBZ / Double(korrekturFaktor) * 10 // Wieviel KH nötig wären
            let korrigiertesIE = bolusIE - (kompensationsKH / 10.0 * mahlzeitenInsulin) // Negative Werte möglich
            
            berechneteIE = korrigiertesIE
        } else {
            berechneteIE = bolusIE + korrekturIE
        }
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
    
    func aktualisiereBZ(_ neuerWert: String) {
        if neuerWert.isEmpty {
            aktuellerBZ = String(zielBZ) // Standardwert setzen
            return
        }
        if let intValue = Int(neuerWert) {
            if intValue <= 40 {
                aktuellerBZ = "40"
            } else if intValue > 450 {
                aktuellerBZ = "450"
            } else {
                aktuellerBZ = neuerWert
            }
        }
    }
    
    func aktualisiereKh(_ neuerWert: String) {
        if neuerWert.isEmpty {
            kohlenhydrate = "" // Leere Eingabe erlauben
            return
        }
        if let intValue = Int(neuerWert) {
            if intValue <= 0 {
            kohlenhydrate = "0"
            } else if intValue > 150 {
                kohlenhydrate = "150"
            }
        } else {
            kohlenhydrate = neuerWert
        }
    }
    

}
