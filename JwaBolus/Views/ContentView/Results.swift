import SwiftUI

struct Results: View {
    @EnvironmentObject var viewModel: BolusViewModel

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Text(NSLocalizedString("results.headline", comment: ""))
                .font(.headline)

            HStack(spacing: 15) {
                ForEach(TimePeriod.allCases, id: \.self) { period in
                    ResultButton(
                        title: period.localizedValue,
                        result: viewModel.resultsPerTimePeriod[period] ?? 0.0,
                        onTap: {
                            viewModel.setInsulinDose(amount: viewModel.resultsPerTimePeriod[period] ?? 0.0)
                            viewModel.updateRemainingInsulin()
                        }
                    )
                }
            }

            Text(NSLocalizedString("results.footnote", comment: ""))
                .multilineTextAlignment(.center)
                .font(.footnote)
        }
        .padding(.horizontal)
    }
}

#Preview {
    Results()
        .environmentObject(BolusViewModel())
        .preferredColorScheme(.dark)
}
