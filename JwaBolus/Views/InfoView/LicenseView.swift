//
//  LicenseView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 26.03.25.
//
import SwiftUI
import MarkdownUI

struct LicenseView: View {
    @State private var licenseText: String = ""

    var body: some View {
        ScrollView {
            Markdown(licenseText)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("license.title")
        .onAppear(perform: loadLicense)
    }

    func loadLicense() {
        guard let path = Bundle.main.path(forResource: "gpl-3.0", ofType: "md"),
              let rawText = try? String(contentsOfFile: path) else {
            licenseText = "⚠️ License text not found."
            return
        }

        let cleanedText = rawText
            // Remove single line breaks within paragraphs to ensure proper paragraph formatting
            .replacingOccurrences(
                of: #"(?<![\n#>-])\n(?![\n#>-])"#,
                with: " ",
                options: .regularExpression
            )
            // Replace Markdown-style links [label](url) → label
            .replacingOccurrences(
                of: #"\[([^\]]+)\]\(([^)]+)\)"#,
                with: "$1",
                options: .regularExpression
            )
            // Replace angle-bracket links <https://...> → [https]://...
            .replacingOccurrences(
                of: #"<(https?)://([^>]+)>"#,
                with: "[$1]://$2",
                options: .regularExpression
            )

        licenseText = cleanedText
    }
}
