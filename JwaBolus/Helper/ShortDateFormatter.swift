//
//  ShortDateFormatter.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 28.02.25.
//

import Foundation

extension DateFormatter {
    static let short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
