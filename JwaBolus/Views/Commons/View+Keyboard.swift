//
//  View+Keyboard.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 13.04.25.
//

import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
