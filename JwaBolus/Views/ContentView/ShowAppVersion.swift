//
//  AppVersionView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 03.03.25.
//

import SwiftUI

struct ShowAppVersion: View {

    var body: some View {

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            Text("Version \(version) (Build \(build))")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
