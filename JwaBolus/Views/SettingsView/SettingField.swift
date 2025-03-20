//
//  SettingField.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 18.03.25.
//
import SwiftUI
import Combine

class DebouncedText: ObservableObject {
    @Published var text: String = ""

    private var cancellable: AnyCancellable?

    init(delay: TimeInterval = 1.0, onCommit: @escaping (String) -> Void) {
        cancellable = $text
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .sink { newValue in
                onCommit(newValue)
            }
    }
}

struct SettingField: View {
    let title: String
    @Binding var text: String
    let onCommit: () -> Void

    @StateObject private var debouncedText: DebouncedText

    init(title: String, text: Binding<String>, onCommit: @escaping () -> Void) {
        self.title = title
        self._text = text
        self.onCommit = onCommit
        _debouncedText = StateObject(wrappedValue: DebouncedText { newValue in
            text.wrappedValue = newValue
            onCommit()
        })
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            TextField("", text: $debouncedText.text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .onAppear {
                    debouncedText.text = text // Initialwert setzen
                }
        }
    }
}
