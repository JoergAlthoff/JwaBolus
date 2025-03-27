//
//  SportIntensityMenu.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 25.03.25.
//
import SwiftUI

struct SportIntensityMenu: View {
    @Binding var sportintensity: SportIntensity

    var body: some View {
        let sportTitle = NSLocalizedString("sport.menu.title", comment: "")
        let selectedSport = sportintensity.localizedName

        return Menu {
            ForEach(SportIntensity.allCases, id: \.self) { option in
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    sportintensity = option
                    KeyboardHelper.hideKeyboard()
                }) {
                    Text(option.localizedName)
                }
                .accessibilityLabel(Text("accessibility.sportintensity.\(option.rawValue)"))
            }
        } label: {
            Text("\(sportTitle) \(selectedSport)")
        }
        .frame(maxWidth: .infinity)
        .padding(4)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(UIColor.systemGray6), lineWidth: 8))
        .menuStyle(DefaultMenuStyle())
        .accessibilityLabel(Text("accessibility.sport.menu"))
    }
}
