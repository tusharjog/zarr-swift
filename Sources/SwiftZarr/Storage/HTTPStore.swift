//
//  HTTPStore.swift
//  ZarrSwift
//
//  Created by Tushar Jog on 12/30/25.
//

import Foundation

public final class HTTPStore: ZarrStore {
    private let baseURL: URL

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    public func get(key: String) throws -> Data? {
        try Data(contentsOf: baseURL.appendingPathComponent(key))
    }

    public func set(key: String, value: Data) throws {
        throw NSError(domain: "HTTPStore", code: 1)
    }

    public func exists(key: String) -> Bool {
        (try? Data(contentsOf: baseURL.appendingPathComponent(key))) != nil
    }

    public func list(prefix: String?) throws -> [String] {
        throw NSError(domain: "HTTPStore", code: 2)
    }
    
    public func delete(key: String) throws {
        throw NSError(domain: "HTTPStore", code: 3)
    }
}
