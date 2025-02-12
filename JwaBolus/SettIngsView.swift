//
//  SettIngsView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 12.02.25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Einstellungen")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("Hier kommen deine Parameter rein!")
                .foregroundColor(.gray)

            Spacer()
        }
    }
}
