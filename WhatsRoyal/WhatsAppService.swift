//
//  WhatsAppService.swift
//  WhatsRoyal
//
//  Created by Joseph Garcia on 30/05/24.
//

import Foundation
import Combine

class WhatsAppService {
    static let shared = WhatsAppService()
    private let baseURL = "http://localhost:3000"

    func sendMessage(_ message: String, to recipient: String) -> AnyPublisher<Bool, Error> {
        guard let url = URL(string: "\(baseURL)/send-message") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "message": message,
            "recipient": recipient
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func fetchMessages() -> AnyPublisher<[Message], Error> {
        guard let url = URL(string: "\(baseURL)/messages") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Message].self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

struct Message: Codable, Identifiable {
    let id: String
    let from: String
    let text: String
    let timestamp: String
}
