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
        Section(header: Text("carbUnit.section.title").font(.headline)) {
            Picker("carbUnit.picker.label", selection: $viewModel.carbUnit) {
                ForEach(CarbUnit.allCases, id: \.self) { unit in
                    Text(unit.localizedName).tag(unit)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}
