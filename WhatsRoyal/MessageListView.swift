//
//  MessageListView.swift
//  WhatsRoyal
//
//  Created by Joseph Garcia on 30/05/24.
//

import SwiftUI

struct MessageListView: View {
    @StateObject private var viewModel = MessageListViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.messages) { message in
                    VStack(alignment: .leading) {
                        Text(message.from)
                            .font(.headline)
                        Text(message.text)
                            .font(.subheadline)
                    }
                }

                NavigationLink(destination: ComposeMessageView()) {
                    Text("Compose")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                Spacer()
            }
            .navigationTitle("Messages")
            .onAppear {
                viewModel.fetchMessages()
            }
            .alert(item: $viewModel.error) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.localizedDescription),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    MessageListView()
}
