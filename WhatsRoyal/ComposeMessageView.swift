//
//  ComposeMessageView.swift
//  WhatsRoyal
//
//  Created by Joseph Garcia on 30/05/24.
//

import SwiftUI

import SwiftUI

struct ComposeMessageView: View {
    @StateObject private var viewModel = ComposeMessageViewModel()

    var body: some View {
        VStack {
            TextField("Recipient", text: $viewModel.recipient)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Enter your message", text: $viewModel.messageText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                viewModel.sendMessage()
            }) {
                if viewModel.isSending {
                    ProgressView()
                } else {
                    Text("Send")
                }
            }
            .padding()
            .disabled(viewModel.messageText.isEmpty || viewModel.recipient.isEmpty || viewModel.isSending)

            Spacer()
        }
        .padding()
        .navigationTitle("Compose Message")
        .alert(isPresented: $viewModel.sendSuccess) {
            Alert(title: Text("Success"), message: Text("Message sent successfully"), dismissButton: .default(Text("Yes?")) {
                viewModel.messageText = ""
                viewModel.recipient = ""
            })
        }
        .alert(item: $viewModel.sendError) { error in
            Alert(title: Text("Error"), message: Text(error.error.localizedDescription), dismissButton: .default(Text("Yes?")))
        }
    }
}

#Preview {
    ComposeMessageView()
}
