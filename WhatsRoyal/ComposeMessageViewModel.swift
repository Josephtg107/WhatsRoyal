//
//  ComposeMessageViewModel.swift
//  WhatsRoyal
//
//  Created by Joseph Garcia on 30/05/24.
//

import Foundation
import Combine

class ComposeMessageViewModel: ObservableObject {
    @Published var messageText = ""
    @Published var recipient = ""
    @Published var isSending = false
    @Published var sendSuccess = false
    @Published var sendError: IdentifiableError?

    private var cancellables = Set<AnyCancellable>()

    func sendMessage() {
        guard !messageText.isEmpty, !recipient.isEmpty else { return }

        isSending = true

        WhatsAppService.shared.sendMessage(messageText, to: recipient)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isSending = false
                switch completion {
                case .failure(let error):
                    self?.sendError = IdentifiableError(error: error)
                case .finished:
                    self?.sendSuccess = true
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
