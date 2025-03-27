# ✅ Localization Clean-Code Audit Checklist (SwiftUI)

This checklist helps ensure your app uses clean and scalable localization techniques in SwiftUI.

---

## 🔤 UI Text Handling

- [x] All visible UI strings are localized using `.strings` files
- [x] No hardcoded text in `Text`, `Button`, `Label`, etc.
- [x] Consistent use of keys in `Localizable.strings`

## 🧠 String Key Design

- [x] Keys are descriptive and namespaced, e.g., `settings.title`, `startButton`
- [x] Keys avoid duplication and ambiguity
- [x] Localized strings contain Markdown where useful (e.g., `**bold**`)

## 📁 Project Structure

- [x] Separate `.strings` files per language (`en.lproj`, `de.lproj`, ...)

## 🧩 Markdown in Text

- [x] Markdown is parsed using `Text(.init(...))` or `MarkdownText` helper
- [x] Localized strings use Markdown minimally and clearly (e.g., emphasis)

## 🌐 Language Support

- [x] At least two localizations exist (e.g., English + German)
- [x] Fallback behavior verified: unknown keys show readable fallback or dev hint

## 🧪 Preview & Debugging

- [x] SwiftUI previews use localized strings
- [x] Optionally isolate debug-only content with preprocessor checks (`#if DEBUG`)

## ♿ Accessibility

- [x] No essential info conveyed only via styled text or color
- [x] Accessibility labels (`accessibilityLabel`) use localized text

## ✏️ Code Style

- [x] Code comments in English (especially for public/Open Source projects)
- [x] Helper types like `MarkdownText` or `.localized` extension used consistently

---

Maintained by: Your Future Self ☕️