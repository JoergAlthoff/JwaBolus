import SwiftUI

struct ResultButton: View {
    let period: TimePeriod
    let result: Double
    let onTap: () -> Void

    @EnvironmentObject var viewModel: BolusViewModel
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            Text(period.localizedValue).bold()

            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                onTap()
            }, label: {
                Text(String(format: "%.1f", result))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(colorScheme == .dark ? Color.orange : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            })
            .buttonStyle(PressableButtonStyle())
            .accessibilityLabel("accessibility.saveResultButton.\(period.rawValue)")
            .accessibilityHint("accessibility.hint.resultButton.\(period.rawValue)")
        }
    }
}

#Preview {
    ResultButton(
        period: .morning,
        result: 2.5,
        onTap: { print("Preview: ResultButton tapped") }
    )
    .environmentObject(BolusViewModel())
    .preferredColorScheme(.dark)
}
