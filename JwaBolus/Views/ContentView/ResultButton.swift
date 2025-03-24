import SwiftUI

struct ResultButton: View {
    let title: String
    let result: Double
    let onTap: () -> Void  // ✅ Korrekt: `onTap` ist eine Closure

    @EnvironmentObject var viewModel: BolusViewModel  // ✅ ViewModel holen
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Text(title).bold()

            Button(action: onTap) {  // ✅ Button ruft jetzt `onTap` korrekt auf
                Text(String(format: "%.1f", result))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(colorScheme == .dark ? Color.orange : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(PressableButtonStyle())
        }
    }
}

#Preview {
    ResultButton(title: "Morning", result: 2.5, onTap: {
        print("Button wurde getippt!")
    })
    .environmentObject(BolusViewModel())
    .preferredColorScheme(.dark)
}
