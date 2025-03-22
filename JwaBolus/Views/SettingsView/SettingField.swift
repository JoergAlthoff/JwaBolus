//
//  SettingField.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 18.03.25.
//
import SwiftUI
import Combine

struct SettingField: View {
    let title: String
    @Binding var text: String
    let onCommit: () -> Void

    @StateObject private var debouncedText: DebouncedText

    private static let numberRegex: String = #"^\d+([.,]\d+)?$"#

    init(title: String, text: Binding<String>, onCommit: @escaping () -> Void = {}) {
        self.title = title
        self._text = text
        self.onCommit = onCommit

        _debouncedText = StateObject(
            wrappedValue: DebouncedText(
                validator: { input in
                    input.range(of: Self.numberRegex, options: .regularExpression) != nil
                },
                onCommit: {
                    text.wrappedValue = $0  // Update external binding after debounce
                    onCommit()
                }
            )   // DebouncedText
        )   // StateObject
    }   // init


    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)

            TextField("", text: $debouncedText.text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .onAppear {
                    debouncedText.text = text
                }
                .onChange(of: text) { oldValue, newValue in
                    if debouncedText.text != newValue {
                        debouncedText.text = newValue
                    }
                }

            if let error = debouncedText.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}
