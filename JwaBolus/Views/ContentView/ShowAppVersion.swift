//
//  ShowAppVersion.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 03.03.25.
//

import SwiftUI

struct ShowAppVersion: View {
    var body: some View {
        if let version = Bundle.main.infoDictionary?[InfoPlistKeys.version] as? String,
           let build = Bundle.main.infoDictionary?[InfoPlistKeys.build] as? String
        {
            Text(
                String(
                    format: NSLocalizedString("app.version.format", comment: ""),
                    version,
                    build
                )
            )
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(.bottom, 10)
        }
    }

    enum InfoPlistKeys {
        static let version = "CFBundleShortVersionString"
        static let build = "CFBundleVersion"
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
