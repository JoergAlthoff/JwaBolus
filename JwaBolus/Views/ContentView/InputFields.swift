//
//  InputFieldsView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 01.03.25.
//
import SwiftUI

struct InputFields: View {
    @ObservedObject var viewModel: BolusViewModel
    @State private var ausgewählteOption: String = "Keiner" // Standardwert

    var body: some View {

        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 8) {

                Text("Aktueller BZ in mg/dl")
                    .foregroundColor(.primary)
                TextField("BZ eingeben", value: $viewModel.aktuellerBZ, format: .number)
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
                TextField("KH eingeben", value: $viewModel.kohlenhydrate, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(4)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                let sportOptionen = ["Keiner", "Leicht", "Mittel", "Intensiv"]
                Menu("Sport innerhalb von 2 Stunden: \(ausgewählteOption)") {
                    ForEach(sportOptionen, id: \.self) { option in
                        Button(option) {
                            ausgewählteOption = option
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
}

#Preview {
    InputFields(viewModel: BolusViewModel())
        .preferredColorScheme(.dark)
}
