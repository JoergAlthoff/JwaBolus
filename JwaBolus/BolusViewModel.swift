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
    @AppStorage("zielBZ") private var zielBZ: Int = 110
    
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
}
