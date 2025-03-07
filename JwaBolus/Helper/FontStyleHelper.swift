//
//  FontStyleHelper.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 04.03.25.
//
// Wird nicht im Projekt verwendet. Dient nur zur anschauung der Fontstyles.
//
//🔹 Große Titel & Überschriften
//•    .largeTitle → Sehr große Überschrift (z.B. für Titelbildschirme).
//•    .title → Große Überschrift.
//•    .title2 → Mittlere Überschrift.
//•    .title3 → Kleine Überschrift.
//
//🔹 Normale Texte
//•    .headline → Fetter Text, oft für hervorgehobene Inhalte.
//•    .subheadline → Kleiner als .headline, oft für Untertitel.
//•    .body → Standard-Fließtext.
//
//🔹 Kleine Texte & Beschriftungen
//•    .callout → Etwas größer als .footnote, für Hinweistexte.
//•    .caption → Sehr kleine Beschriftung, z. B. für Bildunterschriften.
//•    .caption2 → Noch kleiner als .caption.
//•    .footnote → Kleiner Fließtext, oft für Randnotizen oder Hinweise.


import SwiftUI

struct FontStyleHelper: View {
    var body: some View {
        VStack {
            Text("Large Title").font(.largeTitle)
            Text("Title").font(.title)
            Text("Title2").font(.title2)
            Text("Title3").font(.title3)
            
            Text("Headline").font(.headline)
            Text("Subheadline").font(.subheadline)
            Text("Body Text").font(.body)
            
            Text("Callout Text").font(.callout)
            Text("Caption (Bildunterschrift)").font(.caption)
            Text("Caption2 (noch kleiner)").font(.caption2)
            Text("Footnote (Randnotiz)").font(.footnote)
        }
    }
}


#Preview {
    FontStyleHelper()
}
