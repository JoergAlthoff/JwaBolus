//
//  CarbUnitSection.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 22.03.25.
//


import SwiftUI

struct CarbUnitSection: View {
    @EnvironmentObject var viewModel: BolusViewModel

    var body: some View {
        Section(header: Text("Kohlenhydrate Einheit").font(.headline)) {
            Picker("Einheit", selection: $viewModel.carbUnit) {
                ForEach(CarbUnit.allCases, id: \.self) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}