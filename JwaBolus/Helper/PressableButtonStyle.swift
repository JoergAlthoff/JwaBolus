//
//  PressableButtonStyle.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//

import SwiftUI

// Benutzerdefinierter ButtonStyle, der den Button skaliert und die Opazität ändert, wenn er gedrückt wird
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
