//
//  DebouncedText.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 22.03.25.
//
import Combine
import SwiftUI

class DebouncedText: ObservableObject {
    @Published var text: String
    @Published var errorMessage: String?

    private var cancellable: AnyCancellable?
    private let validator: (String) -> Bool
    private let onCommit: (String) -> Void

    init(
        initialText: String = "",
        delay: TimeInterval = 0.7,
        validator: @escaping (String) -> Bool = { _ in true },
        onCommit: @escaping (String) -> Void = { _ in }
    ) {
        text = initialText
        self.validator = validator
        self.onCommit = onCommit

        cancellable = $text
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .sink { [weak self] newValue in
                Log.debug("DebouncedText checking: '\(newValue)'", category: .ui)
                self?.validateAndCommit(newValue)
            }
    }

    func forceCommit() {
        validateAndCommit(text)
    }

    private func validateAndCommit(_ value: String) {
        if validator(value) {
            errorMessage = nil
            onCommit(value)
        } else {
            errorMessage = NSLocalizedString("invalid.input", comment: "")
            Log.info("errorMessage!", category: .ui)
        }
    }
}
