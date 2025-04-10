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
        Section(header: Text("bgunit.section.title").font(.headline)) {
            Picker("bgunit.picker.label", selection: $viewModel.bgunit) {
                ForEach(BloodGlucoseUnit.allCases, id: \.self) { unit in
                    Text(unit.localizedName)
                        .tag(unit)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}
