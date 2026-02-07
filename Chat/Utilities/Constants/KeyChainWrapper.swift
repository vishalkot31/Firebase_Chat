//
//  KeyChainWrapper.swift
//  Chat
//
//  Created by Vishal Kothari on 03/02/26.
//


import Foundation
import Security

//Secure Storage
enum KeychainError: Error {
    case encodingFailed
    case decodingFailed
    case itemNotFound
    case unexpectedStatus(OSStatus)
}


//Singelton class
final class KeychainWrapper {

    static let shared = KeychainWrapper()
    private init() {}

    private let service = Bundle.main.bundleIdentifier ?? "app.keychain"

    // MARK: - Save

    //Keychain only stores Data
    func save<T: Codable>(_ value: T, for key: String) throws {
        let data = try JSONEncoder().encode(value)
        saveData(data, for: key)
    }

    func saveString(_ value: String, for key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.encodingFailed
        }
        saveData(data, for: key)
    }

    private func saveData(_ data: Data, for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    // MARK: - Read

    func read<T: Codable>(_ type: T.Type, for key: String) throws -> T {
        let data = try readData(for: key)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func readString(for key: String) throws -> String {
        let data = try readData(for: key)
        guard let value = String(data: data, encoding: .utf8) else {
            throw KeychainError.decodingFailed
        }
        return value
    }

    private func readData(for key: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }

        guard status == errSecSuccess,
              let data = result as? Data else {
            throw KeychainError.unexpectedStatus(status)
        }

        return data
    }

    // MARK: - Delete

    func delete(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(query as CFDictionary)
    }

    func clearAll() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]

        SecItemDelete(query as CFDictionary)
    }
}
