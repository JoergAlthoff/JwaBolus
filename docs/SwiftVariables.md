# Swift Variable Types Overview

Eine kompakte Referenz zur Verwendung von Variablen in Swift, speziell im SwiftUI-Kontext.

---

## 🔸 Instanz- und Klassenvariablen

| Syntax            | Beschreibung                        | Lebensdauer / Gültigkeit        | Java-Äquivalent            |
|-------------------|--------------------------------------|----------------------------------|-----------------------------|
| `let`             | Konstante, einmalig gesetzt          | Instanzgebunden                  | `final`                    |
| `var`             | Veränderbare Instanzvariable         | Instanzgebunden                  | normale Instanzvariable     |
| `static let`      | Klassenkonstante                     | Für alle Instanzen des Typs      | `static final`              |
| `static var`      | Veränderbare Klassenvariable         | Für alle Instanzen des Typs      | `static`                    |

---

## 🟦 SwiftUI Property Wrappers

| Wrapper               | Zweck                                  | Lebensdauer                | Vergleich zu Java                      |
|-----------------------|----------------------------------------|-----------------------------|----------------------------------------|
| `@State`              | View-lokaler Zustand (Werttypen)       | solange View lebt          | kein direktes Pendant                  |
| `@StateObject`        | Eigentum der View (Referenztypen)      | solange View lebt          | Instanz eines ViewModels               |
| `@ObservedObject`     | View bekommt Objekt von außen          | dynamisch                  | vergleichbar mit Dependency Injection |
| `@EnvironmentObject`  | Kontextabhängige globale Referenz      | App- oder Scene-Lifecycle  | Spring-Context-artige Bereitstellung  |
| `@Binding`            | Bindung an externen Zustand            | solange Parent-View lebt   | Referenz auf fremdes Feld             |

---

## 🛠 Hinweise zur Verwendung

- `@Binding`, `@ObservedObject` → von außen übergeben, im `init()` setzen
- `@State`, `@StateObject` → intern erzeugen, nie von außen setzen
- Zugriff im `init()` auf Wrapper: `self._bindingName = binding`
- `Self.xyz` statt `self.xyz` für statische Properties

---

## ✅ Beispiele im Projekt

Verwendet in:
- `SettingsView.swift`
- `SettingField.swift`
- `DebouncedText.swift`
- `PeriodSettingsView.swift`

---

*Letzte Aktualisierung: März 2025 · Autor: Jörg Althoff mit Swift Copilot 🤖*