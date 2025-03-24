//
//  DebouncedText.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 22.03.25.
//
import SwiftUI
import Combine

class DebouncedText: ObservableObject {
    @Published var text: String
    @Published var errorMessage: String? = nil

    private var cancellable: AnyCancellable?
    private let validator: (String) -> Bool
    private let onCommit: (String) -> Void

    init(
        initialText: String = "",
        delay: TimeInterval = 1.0,
        validator: @escaping (String) -> Bool = { _ in true },
        onCommit: @escaping (String) -> Void = { _ in }
    ) {
        self.text = initialText
        self.validator = validator
        self.onCommit = onCommit

        cancellable = $text
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .sink { [weak self] newValue in
                print("\(Constants.debugDebounceCheck) '\(newValue)'")
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
            errorMessage = NSLocalizedString("invalidInput", comment: "")
            print(errorMessage!)
        }
    }

    private enum Constants {
        static let debugDebounceCheck = "🔎 DebouncedText checking:"
    }
}
