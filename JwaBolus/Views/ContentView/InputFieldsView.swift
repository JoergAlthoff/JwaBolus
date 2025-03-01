//
//  InputFieldsView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 01.03.25.
//
import SwiftUI

struct InputFieldsView: View {
    @Binding var aktuellerBZ: Int
    @Binding var kohlenhydrate: Int
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Aktueller BZ in mg/dl")
                    .foregroundColor(.primary)
                TextField("BZ eingeben", value: $aktuellerBZ, format: .number)
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
                TextField("KH eingeben", value: $kohlenhydrate, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(4)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
    }
}
