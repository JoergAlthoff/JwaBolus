//
//  LocalizedMarkdownText.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 27.03.25.
//
import SwiftUI

/// A SwiftUI Text view that loads a localized string and renders it as Markdown.
struct MarkdownText: View {
    let key: String
    let comment: String

    init(_ key: String, comment: String = "") {
        self.key = key
        self.comment = comment
    }

    var body: some View {
        Text(.init(NSLocalizedString(key, comment: comment)))
    }
}
