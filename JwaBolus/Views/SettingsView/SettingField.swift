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

    init(
        title: String,
        text: Binding<String>,
        onCommit: @escaping () -> Void = {}
    ) {
        let initialText = text.wrappedValue  // Zugriff vor self init

        self.title = title
        self._text = text
        self.onCommit = onCommit

        _debouncedText = StateObject(wrappedValue: DebouncedText(
            initialText: initialText,
            validator: { input in
                let normalized = input.replacingOccurrences(of: ",", with: ".")
                return Double(normalized) != nil
            },
            onCommit: { newValue in
                let normalized = newValue.replacingOccurrences(of: ",", with: ".")
                text.wrappedValue = normalized
                onCommit()
            }
        ))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)

            TextField("", text: $debouncedText.text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .onAppear {
                    print("🟠 SettingField onAppear – text: \(text)")
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

