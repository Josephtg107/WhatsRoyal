//
//  IdentifiableError.swift
//  WhatsRoyal
//
//  Created by Joseph Garcia on 30/05/24.
//

import Foundation

struct IdentifiableError: Identifiable {
    let id = UUID()
    let error: Error
}

extension IdentifiableError: LocalizedError {
    var errorDescription: String? {
        return error.localizedDescription
    }
}

