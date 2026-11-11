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
                    
                    TextField("0x...", text: $viewModel.addressText, axis: .vertical)
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
                    Button("vitalik.eth") {
                        viewModel.fillExample("0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045")
                    }
                    Button("Ronin exploiter (Lazarus)") {
                        viewModel.fillExample("0x098B716B8Aaf21512996dC57EB0615e2383E2f96")
                    }
                }
            }
            .navigationTitle("AML Checker")
            .navigationDestination(item: $viewModel.request) { request in
                ResultView(request: request)
            }
        }
    }
}

#Preview {
    InputView()
}
