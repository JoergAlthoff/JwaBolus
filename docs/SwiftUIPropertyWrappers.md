# SwiftUI Property Wrappers – Übersicht & Zusammenspiel

Diese Datei dokumentiert die wichtigsten Property Wrapper in SwiftUI und wie sie in typischen MVVM-Strukturen zusammenspielen.

---

## 🔄 Datenflussdiagramm

```text
          [App / Scene]
               │
               ▼
   ┌─────────────────────┐
   │  @EnvironmentObject               │ ← Globales ViewModel (z. B. UserSettings)
   └─────────────────────┘
               │
               ▼
    ┌────────────────────┐
    │  ParentView                     │
    │  @StateObject vm                │ ← ViewModel erzeugt & besitzt
    └────────────────────┘
               │
               ▼
  ┌────────────────────────────┐
  │  ViewModel: ObservableObject                  │
  │  @Published properties                        │ ← lösen View-Updates aus
  └────────────────────────────┘
               │
               ▼
    ┌────────────────────┐
    │  ChildView                      │
    │  @ObservedObject vm             │ ← bekommt VM vom Parent
    │  @Binding var text              │ ← bindet @State vom Parent
    └────────────────────┘
               ▲
               │
    ┌────────────────────┐
    │  @State var text                │ ← einfacher lokaler Wert
    └────────────────────┘
```

    # SwiftUI Property Wrappers – Erläuterung der Bausteine

    Diese Übersicht erklärt die wichtigsten Property Wrapper in SwiftUI und wann sie verwendet werden sollten.

    ---

    ## 🧩 Bausteinübersicht

    | Property Wrapper | Beschreibung | Typische Verwendung |
    |------------------|--------------|---------------------|
    | `@State` | Speichert einfache Werte lokal in der View. SwiftUI verwaltet den Wert und triggert Rebuilds bei Änderungen. | Lokale UI-Zustände wie Toggle, Textfeld, Bool |
    | `@Binding` | Referenziert einen `@State`-Wert oder `@Published`-Wert von außen. | Unterviews, die auf Werte aus der Parent-View zugreifen |
    | `@StateObject` | Erstellt und besitzt ein `ObservableObject`, das über den View-Lebenszyklus hinweg bestehen bleibt. | ViewModel, das zur View gehört|
    | `@ObservedObject` | Beobachtet ein von außen übergebenes `ObservableObject`. | ViewModels, die von der Parent-View kommen |
    | `@EnvironmentObject` | Globale Dependency Injection – das Objekt wird über den SwiftUI-Environment bereitgestellt. | App-weite oder scene-weite Shared ViewModels |
    | `@Environment` | Referenziert einen Wert aus dem SwiftUI-Environment. | Lokale UI-Zustände wie Toggle, Textfeld, Bool |
    | `@Published` | Markiert Properties im ViewModel, damit Änderungen automatisch an Views gemeldet werden. | Innerhalb von `ObservableObject`-Klassen |

    ---

    ## 📌 Hinweise

    - **Nur Klassen (Reference Types)** können `@Published` und `ObservableObject` verwenden.
    - **@State und @Binding** funktionieren auch mit Structs, Enums und Value-Types.
    - **@StateObject vs @ObservedObject** ist entscheidend für die Speicherverwaltung:
      - `@StateObject` = View **besitzt** das Objekt
      - `@ObservedObject` = View **nutzt** ein externes Objekt

    ---

    *Autor: Jörg Althoff mit Swift Copilot 🤖 · März 2025*
