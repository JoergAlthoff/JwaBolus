//
//  InfoView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//
import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            WebView(htmlFileName: "HelpText")
                .navigationBarTitle("Info / Hilfe", displayMode: .inline)
                .navigationBarItems(trailing: Button("Fertig") {
                    presentationMode.wrappedValue.dismiss()
                })
        }
    }
}
