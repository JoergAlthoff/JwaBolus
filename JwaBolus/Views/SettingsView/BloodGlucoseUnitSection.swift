//
//  BloodGlucoseUnitSection.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 22.03.25.
//
import SwiftUI

struct BloodGlucoseUnitSection: View {
    @EnvironmentObject var viewModel: BolusViewModel

    var body: some View {
        Section(header: Text("Blutzucker Einheit").font(.headline)) {
            Picker("Einheit", selection: $viewModel.bloodGlucoseUnit) {
                ForEach(BloodGlucoseUnit.allCases, id: \.self) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}
