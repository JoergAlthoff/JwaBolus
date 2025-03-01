//
//  Preview.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 01.03.25.
//

import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark) // Vorschau für Dark Mode
        ContentView()
            .preferredColorScheme(.light) // Vorschau für Light Mode
    }
}
