//
//  ShortDateFormatter.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//

import SwiftUI

    // DateFormatter definieren, um das Datum formatiert anzuzeigen
let shortDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short   // z.B. "15.02.25"
    formatter.timeStyle = .short   // z.B. "13:45"
    return formatter
}()
