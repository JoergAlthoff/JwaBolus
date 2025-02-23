//
//  BolusViewModelTests.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 14.02.25.
//

import XCTest
@testable import JwaBolus

final class BolusViewModelTests: XCTestCase {
    
    var viewModel: BolusViewModel!
    
    override func setUp() {
        super.setUp()

        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            // 🚀 Nur für Tests, keine echte App-Umgebung nötig
            UserDefaults.standard.set(110, forKey: "zielBZ")
            UserDefaults.standard.set(3.0, forKey: "mahlzeitenInsulin")
            UserDefaults.standard.set(20, forKey: "korrekturFaktor")
        }

        viewModel = BolusViewModel()
    }
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
    
    func testBolusBerechnungMitParametern() {
        let testfälle: [(bz: Int, kh: Int, erwartet: Double)] = [
            (0,0,-5.5),
            (80, 80, 22.6),
            (100, 50, 14.5),
            (150, 30, 11.0),
            (200, 20, 10.5),
            (120, 0, 0.5),
            (180, 0, 3.5),
            (381, 0, 13.6),
            (450, 0, 17.0),
            (450,150, 62.0)
        ]
        
        
        for (bz, kh, erwartet) in testfälle {
            viewModel.aktuellerBZ = bz
            viewModel.kohlenhydrate = kh
            
            viewModel.berechneIE()
            
            
            XCTAssertEqual(viewModel.gesamtIE ?? 0, erwartet, accuracy: 0.15,
                           "Fehlgeschlagen für BZ=\(bz), KH=\(kh)")
        }
    }
}
