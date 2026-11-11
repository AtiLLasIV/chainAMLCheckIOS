import SwiftUI

struct ResultView: View {
    @State private var viewModel: ResultViewModel

    init(request: CheckRequest) {
        _viewModel = State(initialValue: ResultViewModel(request: request))
    }

    var body: some View {
        List {
            Section {
                verdict
                Text(viewModel.request.address)
                    .font(.system(.footnote, design: .monospaced))
                    .textSelection(.enabled)
            }

            ForEach(viewModel.rows) { row in
                Section(row.id) {
                    providerContent(row.state)
                }
            }
        }
        .navigationTitle("Сеть: \(viewModel.request.chain.title)")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
        .refreshable { await viewModel.load() }
    }

    @ViewBuilder
    private var verdict: some View {
        if let level = viewModel.overallLevel {
            Label(level.title, systemImage: level.iconName)
                .font(.title3.bold())
                .foregroundStyle(level.color)
        } else {
            HStack {
                ProgressView()
                Text("Проверяем…")
            }
        }
    }

    @ViewBuilder
    private func providerContent(_ state: ResultViewModel.ProviderState) -> some View {
        switch state {
        case .loading:
            ProgressView()
        case .failed(let message):
            Label(message, systemImage: "wifi.exclamationmark")
                .foregroundStyle(.secondary)
        case .loaded(let check):
            if check.flags.isEmpty {
                Label(RiskLevel.clean.title, systemImage: RiskLevel.clean.iconName)
                    .foregroundStyle(RiskLevel.clean.color)
            } else {
                ForEach(check.flags) { flag in
                    Label(flag.title, systemImage: flag.level.iconName)
                        .foregroundStyle(flag.level.color)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ResultView(request: CheckRequest(address: "0x098B716B8Aaf21512996dC57EB0615e2383E2f96", chain: .ethereum))
    }
}
