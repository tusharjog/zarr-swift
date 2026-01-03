//
//  AsyncStoreAdapter.swift
//  ZarrSwift
//
//  Created by Tushar Jog on 12/30/25.
//

import Foundation

/*
public final class AsyncStoreAdapter: AsyncZarrStore {
    public func delete(key: String) async throws {
        try await Task.detached { try self.store.delete(key: key) }.value
    }
    
    private let store: ZarrStore

    public init(_ store: ZarrStore) {
        self.store = store
    }

    public func get(key: String) async throws -> Data? {
        try await Task.detached { try self.store.get(key: key) }.value
    }

    public func set(key: String, value: Data) async throws {
        try await Task.detached { try self.store.set(key: key, value: value) }.value
    }

    public func exists(key: String) async -> Bool {
        await Task.detached { self.store.exists(key: key) }.value
    }

    public func list(prefix: String?) async throws -> [String] {
        try await Task.detached { try self.store.list(prefix: prefix) }.value
    }
}
*/
