//
//  KeyboardHelper.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 15.03.25.
//
import SwiftUI

struct KeyboardHelper {
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
