import SwiftUI

struct StartButton: View {
    @EnvironmentObject var viewModel: BolusViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: {
            KeyboardHelper.hideKeyboard()
            viewModel.calculateInsulinDose()
        }) {
            Text("Start")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(colorScheme == .dark ? Color.orange : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

#Preview {
    StartButton()
        .environmentObject(BolusViewModel())
        .preferredColorScheme(.dark)
}
