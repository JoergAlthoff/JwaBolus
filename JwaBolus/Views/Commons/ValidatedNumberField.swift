//
//  SettingField.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 18.03.25.
//
import Combine
import SwiftUI

struct ValidatedNumberField: View {
    let title: String
    @Binding var text: String
    let onCommit: () -> Void

    @StateObject private var debouncedText: DebouncedText

    private let initialText: String

    init(title: String, text: Binding<String>, onCommit: @escaping () -> Void = { }) {
        let formatter = NumberFormatter.localizedDecimal

        let initialText = formatter.string(from: NSNumber(value: Double(text.wrappedValue) ?? 0)) ?? ""
        self.initialText = initialText

        self.title = title
        _text = text
        self.onCommit = onCommit

        _debouncedText = StateObject(wrappedValue: DebouncedText(
            initialText: initialText,
            validator: { input in
                formatter.number(from: input) != nil
            },
            onCommit: { newValue in
                guard let number = formatter.number(from: newValue) else {
                    text.wrappedValue = ""
                    onCommit()
                    return
                }
                text.wrappedValue = formatter.string(from: number) ?? ""
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
                    debouncedText.text = NumberFormatter.localizedDecimal.string(
                        from: NSNumber(value: Double(text) ?? 0)
                    ) ?? ""
                }
                .onChange(of: text) { _, newValue in
                    let localized = NumberFormatter.localizedDecimal.string(
                        from: NSNumber(value: Double(newValue) ?? 0)
                    ) ?? ""
                    if debouncedText.text != localized {
                        debouncedText.text = localized
                    }
                }
            if let error = debouncedText.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .onAppear {
            print("📦 initialText: \(initialText)")
            print("📦 debouncedText.text: \(debouncedText.text)")
            print("📦 text binding: \(text)")
            debouncedText.text = text
        }
    }
}
