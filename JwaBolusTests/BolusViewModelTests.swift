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
        viewModel = BolusViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
        
    func testBolusBerechnungMitParametern() {
        let testfälle: [(bz: Int, kh: Int, erwartet: Double)] = [
            (80, 80, 26.5),
            (100, 50, 17),
            (150, 30, 12.5),
            (200, 20, 11.5)
        ]
        
        for (bz, kh, erwartet) in testfälle {
            viewModel.aktuellerBZ = bz
            viewModel.kohlenhydrate = kh
            
            viewModel.berechneIE()
            
            XCTAssertEqual(viewModel.gesamtIE ?? 0, erwartet, accuracy: 0.1,
                           "Fehlgeschlagen für BZ=\(bz), KH=\(kh)")
        }
    }
}
