import SwiftUI

struct InputView: View {
    @State private var viewModel = InputViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Сеть", selection: $viewModel.chain) {
                        ForEach(Chain.allCases) { chain in
                            Text(chain.title).tag(chain)
                        }
                    }
                    
                    TextField(viewModel.chain.addressPlaceholder, text: $viewModel.addressText, axis: .vertical)
                        .font(.system(.body, design: .monospaced))
                        .lineLimit(2...3)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    PasteButton(payloadType: String.self) { strings in
                        viewModel.fillExample(strings.first ?? "")
                    }
                    
                } header: {
                    Text("Адрес кошелька")
                } footer: {
                    if let error = viewModel.errorMessage {
                        Text(error).foregroundStyle(.red)
                    }
                }
                
                Section {
                    Button("Проверить") {
                        viewModel.submit()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(viewModel.addressText.isEmpty)
                }
                
                Section("Примеры") {
                    ForEach(viewModel.examples) { example in
                        Button(example.title) {
                            viewModel.fillExample(example.address)
                        }
                    }
                }
            }
            .navigationDestination(item: $viewModel.request) { request in
                ResultView(request: request)
            }
        }
    }
}

#Preview {
    InputView()
}
