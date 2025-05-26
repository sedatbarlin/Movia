//
//  KeychainError.swift
//  Movia
//
//  Created by Sedat on 26.05.2025.
//

import Foundation

enum KeychainError: Error {
    case duplicateEntry
    case unknown(OSStatus)
    case itemNotFound
    case invalidData
}
