//
//  InfoView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//
import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            WebView(htmlFileName: "HelpText")
                .navigationBarTitle("Info / Hilfe", displayMode: .inline)
                .navigationBarItems(trailing: Button("Fertig") {
                    dismiss()
                })
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
