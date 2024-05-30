//
//  MessageListViewModel.swift
//  WhatsRoyal
//
//  Created by Joseph Garcia on 30/05/24.
//

import Combine
import Foundation

class MessageListViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var error: IdentifiableError?

    private var cancellables = Set<AnyCancellable>()

    func fetchMessages() {
        WhatsAppService.shared.fetchMessages()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = IdentifiableError(error: error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] messages in
                self?.messages = messages
            })
            .store(in: &cancellables)
    }
}
