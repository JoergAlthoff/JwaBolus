//
//  HelpContentView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 26.03.25.
//


import SwiftUI

struct HelpContentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                SectionTitle("help.title.purpose")
                Text("help.content.purpose")

                SectionTitle("help.title.logic")
                Text("help.content.logic")

                SectionTitle("help.title.sport")
                Text("help.content.sport")

                SectionTitle("help.title.usage")
                Text("help.content.usage")
                
                SectionTitle("help.title.disclaimer")
                Text("help.content.disclaimer")

                SectionTitle("help.title.privacy")
                Text("help.content.privacy")

                SectionTitle("help.title.license")
                NavigationLink("help.content.license") {
                    LicenseView()
                }
                .padding(.bottom)
            }
            .padding()
        }
        .navigationTitle("help.navTitle")
    }
}

struct SectionTitle: View {
    let key: LocalizedStringKey
    init(_ key: String) { self.key = LocalizedStringKey(key) }

    var body: some View {
        Text(key)
            .font(.title3)
            .bold()
            .padding(.bottom, 2)
    }
}
