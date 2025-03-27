import SwiftUI

struct StartButton: View {
    @EnvironmentObject var viewModel: BolusViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            KeyboardHelper.hideKeyboard()
            viewModel.calculateInsulinDose()
        }) {
            Text("start.button.title")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(colorScheme == .dark ? Color.orange : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .accessibilityLabel(Text("accessibility.startButton"))
        .accessibilityHint(Text("accessibility.hint.startButton"))
    }
}

#Preview {
    StartButton()
        .environmentObject(BolusViewModel())
        .preferredColorScheme(.dark)
}
