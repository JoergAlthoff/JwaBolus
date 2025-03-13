//
//  InputFieldsView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 01.03.25.
//
import SwiftUI

struct InputFields: View {
    @ObservedObject var viewModel: BolusViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Aktueller BZ in mg/dl")
                    .foregroundColor(.primary)
                TextField("BZ eingeben", value: $viewModel.currentBG, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(4)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Text("Kohlenhydrate g")
                    .foregroundColor(.primary)
                TextField("KH eingeben", value: $viewModel.carbohydrates, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(4)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    Menu("Sport innerhalb von 2 Stunden: \(viewModel.sportIntensity.rawValue)") {
                        ForEach(SportIntensity.allCases, id: \.self) { option in
                            Button(option.rawValue) {
                                viewModel.sportIntensity = option
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(4)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(UIColor.systemGray6), lineWidth: 8))
                    .menuStyle(DefaultMenuStyle()) // Standard iOS-Design
                }
                .padding()
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                resetValues()
            }
        }
    }

    private func resetValues() {
        viewModel.currentBG = 0
        viewModel.carbohydrates = 0
        viewModel.sportIntensity = .keiner
    }
}

#Preview {
    InputFields(viewModel: BolusViewModel())
        .preferredColorScheme(.dark)
}
