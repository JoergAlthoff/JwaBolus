//
//  Log.swift
//  JwaBolus
//
//  Created by Joerg Althoff on 31.02.2025.
//  Copyright © 2025 Joerg Althoff. All rights reserved.
//
//  This file is part of the JwaBolus project, licensed under GPL-3.0
//  with additional attribution requirements as described in the LICENSE.md.
//
import os

enum Log {
    private static let subsystem = "de.jalthoff.jwabolus"

    private static let general = Logger(subsystem: subsystem, category: "general")
    // swiftlint:disable identifier_name
    private static let ui = Logger(subsystem: subsystem, category: "ui")
    // swiftlint:enable identifier_name
    private static let logic = Logger(subsystem: subsystem, category: "logic")
    private static let healthkit = Logger(subsystem: subsystem, category: "healthkit")
    private static let storage = Logger(subsystem: subsystem, category: "storage")
    private static let network = Logger(subsystem: subsystem, category: "network")

    static func debug(_ message: String, category: Category = .general) {
        #if DEBUG
        let decorated = "🔍 " + emoji(for: category) + " " + message
        logger(for: category).debug("\(decorated, privacy: .public)")
        #endif
    }

    static func info(_ message: String, category: Category = .general) {
        let decorated = "ℹ️ " + emoji(for: category) + " " + message
        logger(for: category).info("\(decorated, privacy: .public)")
    }

    static func warning(_ message: String, category: Category = .general) {
        let decorated = "⚠️ " + emoji(for: category) + " " + message
        logger(for: category).info("\(decorated, privacy: .public)")
    }

    static func error(_ message: String, category: Category = .general) {
        let decorated = "❌ " + emoji(for: category) + " " + message
        logger(for: category).error("\(decorated, privacy: .public)")
    }

    static func fault(_ message: String, category: Category = .general) {
        let decorated = "🔥 " + emoji(for: category) + " " + message
        logger(for: category).fault("\(decorated, privacy: .public)")
    }

    enum Category {
        case general
        // swiftlint:disable identifier_name
        case ui
        // swiftlint:enable identifier_name
        case logic
        case healthkit
        case storage
        case network
    }

    private static func logger(for category: Category) -> Logger {
        switch category {
        case .general:
            return general
        case .ui:
            return ui
        case .logic:
            return logic
        case .healthkit:
            return healthkit
        case .storage:
            return storage
        case .network:
            return network
        }
    }

    private static func emoji(for category: Category) -> String {
        switch category {
        case .general: return "📦"
        case .ui: return "🎨"
        case .logic: return "🧠"
        case .healthkit: return "❤️"
        case .storage: return "💾"
        case .network: return "🌐"
        }
    }
}
