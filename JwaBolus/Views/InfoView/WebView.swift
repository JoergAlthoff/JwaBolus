//
//  WebView.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 01.03.25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let htmlFileName: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let fileURL = Bundle.main.url(forResource: htmlFileName, withExtension: "html") else {
            print("❌ HTML-Datei nicht gefunden: \(htmlFileName).html")
            return
        }
        
        print("✅ Lade HTML-Datei von: \(fileURL)")
        uiView.loadFileURL(fileURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
    }
}
