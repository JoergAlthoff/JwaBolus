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
    
    func testBerechneIE_MitKorrekturUndBolus() {
        // Given
        viewModel.aktuellerBZ = "180"
        viewModel.kohlenhydrate = "50"
        
        // When
        viewModel.berechneIE()
        
        // Then
        let erwarteterBolus = 50.0 / 10.0 * 3.5
        let erwarteteKorrektur = Double(180 - 110) / 20.0
        let erwartetesGesamtIE = erwarteterBolus + erwarteteKorrektur
        
        XCTAssertEqual(viewModel.berechneteIE ?? 0.0, erwartetesGesamtIE, accuracy: 0.1)
    }
    
    func testBerechneIE_KeinKorrekturInsulinWennBZUnterZiel() {
        // Given
        viewModel.aktuellerBZ = "90"
        viewModel.kohlenhydrate = "50"
        
        // When
        viewModel.berechneIE()
        
        // Then
        XCTAssertEqual(viewModel.berechneteIE ?? 0.0, 50 / 10 * 3.5, accuracy: 0.1)
    }
    
    func testBerechneIE_KeinInsulinWennKHUndBZZuNiedrig() {
        // Given
        viewModel.aktuellerBZ = "80"
        viewModel.kohlenhydrate = "0"
        
        // When
        viewModel.berechneIE()
        
        // Then
        XCTAssertEqual(viewModel.berechneteIE, 0.0)
    }
}
