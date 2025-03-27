import SwiftUI

struct ResultButton: View {
    let title: String
    let result: Double
    let onTap: () -> Void

    @EnvironmentObject var viewModel: BolusViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Text(title).bold()

            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                onTap()
            }) {
                Text(String(format: "%.1f", result))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(colorScheme == .dark ? Color.orange : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(PressableButtonStyle())
            .accessibilityLabel(Text("accessibility.saveResultButton.\(title.lowercased())"))
            .accessibilityHint(Text("accessibility.hint.resultButton.\(title.lowercased())"))
            // TODO: Hier noch mal wegen rawValue schauen
        }
    }
}

#Preview {
    ResultButton(title: "Morning", result: 2.5, onTap: {
        print("ResultButton was tapped!")
    })
    .environmentObject(BolusViewModel())
    .preferredColorScheme(.dark)
}
